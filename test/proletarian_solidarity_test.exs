defmodule ProletarianSolidarityTest do
  use ExUnit.Case
  import ProletarianSolidarity.Factory
  import Mox

  alias ProletarianSolidarity.Bot.Notifier

  @msg "The money have been economed"

  setup do
    defmock(MockTelegramApi, for: Telegram.ChatBot)
    defmock(APIMock, for: ProletarianSolidarity.Bot.ApiClient)
    Application.put_env(:proletarian_solidarity, :t_api_client, APIMock)
    :ok
  end

  test "message handle test" do
    expect(MockTelegramApi, :handle_update, fn message, token, state ->
      state = %{state | capital: state.capital + 10}
      text = "#{@msg}: #{state.capital}"
      %{text: text}
    end)

    msg = build(:message, %{})

    assert %{
             text: "#{@msg}: 110"
           } == MockTelegramApi.handle_update(msg, "test_token", %{capital: 100})
  end

  describe "test backgoud notify task" do
    test "notify" do
      n = 100
      parent_pid = self()

      expect(APIMock, :send_msg, n, fn _token, chat_id, text ->
        send(parent_pid, {:ok, chat_id, text})
      end)

      expect(APIMock, :get_token, n, fn ->
        "test_token"
      end)

      pid = Process.whereis(Notifier)
      allow(APIMock, parent_pid, pid)
      Notifier.set_state(parent_pid, %{capital: 100, chat_id: 10})
      :timer.sleep(5000)

      assert_receive {:ok, 10, "Capital for donation 100 RUB\n"}, 5000
    end
  end
end
