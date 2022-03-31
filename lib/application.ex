defmodule ProletarianSolidarity.Application do

  use Application

  @impl Application
  def start(_type, _args) do
    IO.puts "STARTING BOT"
    token = Application.fetch_env!(:proletarian_solidarity, :token_counter_bot)
    options = [purge: true, max_bot_concurrency: 1000]

    children = [
      {Telegram.Bot.ChatBot.Supervisor, {ProletarianSolidarity.Bot, token, options}}
    ]

    opts = [strategy: :one_for_one, name: ProletarianSolidarity.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
