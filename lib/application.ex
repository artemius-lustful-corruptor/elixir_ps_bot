defmodule ProletarianSolidarity.Application do

  use Application

  @impl Application
  def start(_type, _args) do
    IO.puts "STARTING BOT"
    token = Application.fetch_env!(:proletarian_solidarity, :token)
    options = [purge: true, max_bot_concurrency: 1000, name: :test_bot]

    children = [
      {Telegram.Bot.ChatBot.Supervisor, {ProletarianSolidarity.Bot, token, options}},
      #ProletarianSolidarity.Bot.Notifier
    ]

    opts = [strategy: :one_for_one, name: ProletarianSolidarity.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
