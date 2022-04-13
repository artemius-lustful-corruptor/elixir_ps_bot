defmodule ProletarianSolidarity.Bot.Notifier do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_state(pid) do
    GenServer.call(__MODULE__, {:get, pid})
  end

  def set_state(pid, state) do
    GenServer.cast(__MODULE__, {:set, {pid, state}})
  end

  # Server

  @impl true
  def init(state) do
    IO.inspect("Notifyer start")
    notify()
    {:ok, state}
  end

  @impl true
  def handle_call({pid, :get}, _from, state) do
    new_state = Map.get(state, pid, %{})
    {:reply, new_state, state}
  end

  @impl true
  def handle_cast({:set, {pid, data}}, state) do
    new_state = Map.put(state, pid, data)
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:notify, state) do
    token = api().get_token()
    keys = Map.keys(state)

    new_state =
      Enum.reduce(keys, state, fn pid, state_acc ->
        {client_state, state} = Map.pop(state_acc, pid)
        chat_id = Map.get(client_state, :chat_id)
        capital = Map.get(client_state, :capital)

        text = """
        Capital for donation #{capital} RUB
        """

        api().send_msg(token, chat_id, text)
        api().send_msg(token, chat_id, "/paided")
        state
      end)

    notify()
    {:noreply, new_state}
  end

  defp notify() do
    Process.send_after(self(), :notify, period())
  end

  defp api(), do: Application.get_env(:proletarian_solidarity, :t_api_client)
  defp period(), do: Application.get_env(:proletarian_solidarity, :period)
end
