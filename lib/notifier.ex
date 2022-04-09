defmodule ProletarianSolidarity.Bot.Notifier do
  use GenServer

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get)
  end

  def set_state(state) do
    GenServer.call(__MODULE__, {:set, state})
  end

  # Server

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:set, data}, _from, state) do
    capital = data.capital
    new_state = %{state | capital: state.capital + capital}
    {:reply, new_state}
  end

  #   use Task

  #   # @period 30 * 1000 * 86400 #move to config
  #   @period 1000
  #   def start_link(_args) do
  #     Task.start_link(&run/0)
  #   end

  #   defp run() do
  #     receive do
  #     after
  #       @period ->
  #         notify()
  #         run()
  #     end
  #   end

  #   defp notify() do
  #     # 1. to get state
  #     # 2. to create PS_API.ex
  #     # 3. to create send_msg func in PS_API.ex
  #     state = %{capital: 245}
  #     IO.inspect("sended")
  #     :ok
  #   end
end
