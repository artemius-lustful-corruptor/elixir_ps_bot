use Mix.Config

config :proletarian_solidarity,
  token: System.fetch_env!("TOKEN_COUNTER_BOT")
config :proletarian_solidarity,
  period: 30 * 1000 * 86400 # that is 30 days
