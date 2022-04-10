import Config

config :proletarian_solidarity,
  token: System.get_env("TOKEN_COUNTER_BOT", nil)
config :proletarian_solidarity,
  period: 1000
