defmodule ProletarianSolidarity.Bot do
  @moduledoc """
  The `ProletarianSolidarity` is the functional module for
  Telegram bot with same name. The main purpose - to help to economy
  money for supporting some working organizations.
  """
  require Logger

  alias ProletarianSolidarity.Bot.API
  alias ProletarianSolidarity.Bot.Notifier

  @behaviour Telegram.ChatBot

  use GenServer

  def start_link(_args) do
    IO.inspect("Start link")
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  #@impl Telegram.ChatBot
  #@spec init :: {:ok, %{capital: 0, count: 0}}
  def init(_args) do
    count_state = 0
    IO.inspect(self())

    
    
    {:ok,
     %{
       count: count_state,
       capital: 0
     }}
  end

  @impl Telegram.ChatBot
  @spec handle_update(any, any, any) :: {:ok, any}
  def handle_update(%{"message" => %{"chat" => %{"id" => chat_id}}, "text" => text}, token, state) do
    IO.inspect(self())
    money =
      text
      |> String.splitter([" ", ",", ":", "-", "_", "->"])
      |> Enum.into([])
      |> case do
        [_item, price] ->
          get_price(price)

        _ ->
          error(token, chat_id)
          0
      end

    new_state = %{state | capital: state.capital + money}
    #Notifier.set_state(new_state)
    Logger.debug("#{inspect(new_state)}")

    text = "The total capital has been economed: #{new_state.capital}"
    API.send_msg(token, chat_id, text)

    {:ok, new_state}
  end

  def handle_update(%{"message" => %{"chat" => %{"id" => chat_id}}}, token, state) do
    IO.inspect(self())
    error(token, chat_id)
    {:ok, %{state | capital: 100}}
  end

  def handle_update(msg, _token, state) do
    Logger.warn("Unexpected message: #{inspect(msg)} has been handled")
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    IO.inspect(state)
    {:ok, state}
  end
  

  defp get_price(price) when is_integer(price), do: price

  defp get_price(price) do
    case Integer.parse(price) do
      {value, _} ->
        value

      :error ->
        Logger.error("Useless characters in #{price}")
        0
    end
  end

  defp error(token, chat_id) do
    text = """
    Error! Doesn't support that message format. 
    Please use this format: 'ITEM' delimiter 'PRICE'.
    The delimiter may be one of [" ", ",", ":", "-", "_", "->"]
    """

    API.send_msg(token, chat_id, text)
  end
end
