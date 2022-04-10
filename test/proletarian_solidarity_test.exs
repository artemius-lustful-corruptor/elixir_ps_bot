defmodule ProletarianSolidarityTest do
  use ExUnit.Case
  import ProletarianSolidarity.Factory
  import Mox

  alias ProletarianSolidarity.Bot.Notifier
  
  defmock(MockTelegramApi, for: Telegram.ChatBot)
  defmock(API, for: ProletarianSolidarity.Bot.API)
  @msg "The money have been economed"

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

      expect(API, :send_msg, fn _token, chat_id, text ->
        IO.inspect("sending msg")
        {:ok, chat_id, text}
      end)

      expect(API, :get_token, fn ->
        IO.inspect("get_token")
        "test_token"
        
      end)
      
      start_supervised(Notifier)
      Notifier.set_state(self(), %{capital: 100, chat_id: 10})
      #:timer.sleep(5000)

      assert_receive {:ok, 10, "test"}, 5000
    end
  end
end
