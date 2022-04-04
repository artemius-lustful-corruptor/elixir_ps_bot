defmodule ProletarianSolidarity.Factory do
  use ExMachina

  def message_factory do
    %{
      "message" => %{
        "chat" => %{
          "first_name" => "Artem",
          "id" => 466_947,
          "last_name" => "Salagaev",
          "type" => "private",
          "username" => "TestUser"
        },
        "date" => 1_649_754,
        "from" => %{
          "first_name" => "Artem",
          "id" => 466_947,
          "is_bot" => false,
          "language_code" => "ru",
          "last_name" => "Salagaev",
          "username" => "ArtemGits"
        },
        "message_id" => 117,
        "text" => "Апр 30"
      },
      "update_id" => 207_179_287
    }
  end
end
