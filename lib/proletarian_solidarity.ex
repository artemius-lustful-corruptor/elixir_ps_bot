defmodule ProletarianSolidarity.Bot do
  @moduledoc """
  Documentation for `ProletarianSolidarity`.
  """

  @behaviour Telegram.ChatBot

  @impl Telegram.ChatBot
  def init() do
    count_state = 0
    {:ok, %{
        count: count_state,
        capital: 0
     }}
  end

  @impl Telegram.ChatBot
  def handle_update(
        %{"message" => %{"text" => "/reset", "chat" => %{"id" => chat_id}}},
        token,
        state
      ) do
    Telegram.Api.request(token, "sendMessage",
      chat_id: chat_id,
      text: "Reset message counter (it was #{state.count})"
    )

    {:ok, 0}
  end

  def handle_update(
        %{"message" => %{"text" => "/stop", "chat" => %{"id" => chat_id}}},
        token,
        state
      ) do
    Telegram.Api.request(token, "sendMessage",
      chat_id: chat_id,
      text: "Counter destroyed, bye!"
    )

    {:stop, state}
  end

  # def handle_update(%{"message" => %{"chat" => %{"id" => chat_id}}}, token, state) do
  #   count_state = state.count + 1

  #   Telegram.Api.request(token, "sendMessage",
  #     chat_id: chat_id,
  #     text: "Hey! You sent me #{count_state} messages"
  #   )

  #   {:ok, state}
  # end

  def handle_update(%{"message" => %{"chat" => %{"id" => chat_id}} = message}, token, state) do
    money =
      message["text"]
      |> String.split(" ") |> IO.inspect()
      |> case do
           [item, price]  ->
             String.to_integer(price) #TODO to create more smart algorithm
           _ ->
             0
         end
      
    
      new_state = %{state | capital: state.capital + money}
      IO.inspect(new_state)
      Telegram.Api.request(token, "sendMessage",
        chat_id: chat_id,
        text: "The total capital has been economed: #{new_state.capital}"
      )
      
    {:ok, new_state}
  end

  def handle_update(_update, _token, state) do
    # Unknown update
    {:ok, state}
  end
end
