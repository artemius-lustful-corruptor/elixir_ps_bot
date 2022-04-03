import Config

config :proletarian_solidarity,
  token_counter_bot: System.get_env("TOKEN_COUNTER_BOT", nil)
