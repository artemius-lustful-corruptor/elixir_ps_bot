defmodule ProletarianSolidarity.Bot do
  @moduledoc """
  Documentation for `ProletarianSolidarity`.
  """
  require Logger

  @behaviour Telegram.ChatBot

  @impl Telegram.ChatBot
  def init() do
    count_state = 0
    {:ok, %{
        count: count_state,
        capital: 0
     }}
  end

  #TODO to know how to handle messages with pictures, audio, video, or quotes, comments
  @impl Telegram.ChatBot
  def handle_update(%{"message" => %{"chat" => %{"id" => chat_id}} = message}, token, state) do
    money =
      message["text"]
      |> String.splitter([" ", ",", ":", "-", "_", "->"]) |> IO.inspect() #TODO split string by [:, -, ->]
      |> case do
           [item, price]  ->
             String.to_integer(price) #TODO to create more smart algorithm
           _ ->
             error(token, chat_id)
             0
         end
      
    
      new_state = %{state | capital: state.capital + money}
      Logger.debug(new_state)
      Telegram.Api.request(token, "sendMessage",
        chat_id: chat_id,
        text: "The total capital has been economed: #{new_state.capital}"
      )
      
    {:ok, new_state}
  end

  def handle_update(msg, _token, state) do
    Logger.warn("Unexpected message: #{inspect(msg)} has been handled")
    {:ok, state}
  end

  defp error(token, chat_id) do
     Telegram.Api.request(token, "sendMessage",
        chat_id: chat_id,
        text: """
        Error! Doesn't support that message format. 
        Please use this format: 'ITEM' delimiter 'PRICE'.
        The delimiter may be one of [" ", ",", ":", "-", "_", "->"]
        """
      )
  end
  
end
