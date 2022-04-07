defmodule ProletarianSolidarityTest do
  use ExUnit.Case
  import ProletarianSolidarity.Factory
  import Mox

  defmock(MockTelegramApi, for: Telegram.ChatBot)

  @msg "The money have been economed"

  test "message handle test" do
    expect(MockTelegramApi, :handle_update, fn message, token, state ->
      chat_id = 1
      state = %{state | capital: state.capital + 10}
      text = "#{@msg}: #{state.capital}"
      %{chat_id: chat_id, text: text}
    end)

    msg = build(:message, %{})
    assert %{
             chat_id: 1,
             text: "#{@msg}: 110"
           } == MockTelegramApi.handle_update(msg, "test_token", %{capital: 100})
  end


  describe "test backgoud notify task" do
    test "notify" do
      start_supervised(ProletarianSolidarity.Bot.Notifier)
      :timer.sleep(5000)
    end
  end
end
