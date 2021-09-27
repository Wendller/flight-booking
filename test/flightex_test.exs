defmodule FlightexTest do
  use ExUnit.Case

  describe "create_user/1" do
    test "when correct params are passed, returns a tuple" do
      Flightex.start_agents()

      params = %{
        name: "Wend",
        email: "wend@mail.com",
        cpf: "12345678911"
      }

      assert {:ok, _uuid} = Flightex.create_user(params)
    end
  end

  describe "create_booking/1" do
    test "when correct params are passed, returns a tuple" do
      Flightex.start_agents()

      params = %{
        complete_date: ~N[2001-05-07 03:05:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "e9f7d281-b9f2-467f-9b34-1b284ed58f9e"
      }

      assert {:ok, _uuid} = Flightex.create_booking(params)
    end
  end

  describe "get_booking/1" do
    test "should return a booking" do
      Flightex.start_agents()

      params = %{
        complete_date: ~N[2001-05-07 03:05:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "e9f7d281-b9f2-467f-9b34-1b284ed58f9e"
      }

      {:ok, uuid} = Flightex.create_booking(params)

      assert {:ok, _booking} = Flightex.get_booking(uuid)
    end
  end
end
