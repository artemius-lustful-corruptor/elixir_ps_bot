defmodule ProletarianSolidarity.Bot.Notifier do
  use GenServer

  alias ProletarianSolidarity.Bot.API

  # @period 30 * 1000 * 86400 #move to config
  @period 1000

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
    new_state = Map.put(state, pid, data) |> IO.inspect()
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:notify, state) do
    token = API.get_token()
    # TODO iterate over pids
    keys = Map.keys(state)

    Enum.each(keys, fn pid ->
      client_state = Map.get(state, pid)
      chat_id = Map.get(client_state, :chat_id)
      text = Map.get(client_state, :capital)
      IO.inspect(state)
      API.send_msg(token, chat_id, text)
    end)

    notify()
    {:noreply, state}
  end

  defp notify() do
    Process.send_after(self(), :notify, @period)
  end
end
