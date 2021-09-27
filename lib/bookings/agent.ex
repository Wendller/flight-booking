defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    booking_id = UUID.uuid4()

    Agent.update(__MODULE__, fn agent_state -> update_state(agent_state, booking, booking_id) end)

    {:ok, booking_id}
  end

  defp update_state(agent_state, %Booking{} = booking, booking_id) do
    Map.put(agent_state, booking_id, booking)
  end

  def get(uuid), do: Agent.get(__MODULE__, fn agent_state -> get_booking(agent_state, uuid) end)

  def get_all, do: Agent.get(__MODULE__, fn agent_state -> get_bookings_list(agent_state) end)

  defp get_booking(agent_state, uuid) do
    case Map.get(agent_state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end

  defp get_bookings_list(agent_state), do: Map.values(agent_state)
end
