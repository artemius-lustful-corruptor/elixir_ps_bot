defmodule ProletarianSolidarity.Bot.API do

  alias ProletarianSolidarity.Bot
  
  def get_token(), do: Application.get_env(:proletarian_solidarity, :token)
  
  def send_msg(token, chat_id, text) do
    Telegram.Api.request(token, "sendMessage",
      chat_id: chat_id,
      text: text
    )
  end

  def get_state() do
    :sys.get_state(ProletarianSolidarity.Bot) |> IO.inspect()
  end

end
