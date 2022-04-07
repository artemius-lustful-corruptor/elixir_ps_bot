defmodule ProletarianSolidarity.Bot.Notifier do
  use Task

  # @period 30 * 1000 * 86400 #move to config
  @period 1000
  def start_link(_args) do
    Task.start_link(&run/0)
  end

  defp run() do
    receive do
    after
      @period ->
        notify()
        run()
    end
  end

  defp notify() do
    # 1. to get state
    # 2. to create PS_API.ex
    # 3. to create send_msg func in PS_API.ex
    state = %{capital: 245}
    IO.inspect("sended")
    :ok
  end
end
