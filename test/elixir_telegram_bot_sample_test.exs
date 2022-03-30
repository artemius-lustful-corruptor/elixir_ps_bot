defmodule ElixirTelegramBotSampleTest do
  use ExUnit.Case
  doctest ElixirTelegramBotSample

  test "greets the world" do
    assert ElixirTelegramBotSample.hello() == :world
  end
end
