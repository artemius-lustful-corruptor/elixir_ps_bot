use Mix.Config

config :app,
  bot_name: "first_elixir_bot"

config :nadia,
  token: "5175304747:AAFB3KP3wpYFQw4O_czaF_UfYgUiK1bqv1Q"

import_config "#{Mix.env}.exs"
