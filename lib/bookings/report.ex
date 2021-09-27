defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate_report(from_date, to_date) do
    BookingAgent.get_all()
    |> validate_bookings_date_interval(from_date, to_date)
    |> Enum.filter(fn booking -> is_struct(booking) end)
    |> Enum.map(fn booking -> stringfy_booking(booking) end)
    |> generate("report-test.csv")
  end

  def generate(valid_booking_list, filename \\ "report.csv") do
    File.write(filename, valid_booking_list)

    {:ok, "Report generated successfully"}
  end

  defp validate_bookings_date_interval(bookings_list, from_date, to_date) do
    bookings_list
    |> Enum.map(fn booking -> validate_booking_date(booking, from_date, to_date) end)
  end

  defp validate_booking_date(%Booking{complete_date: complete_date} = booking, from_date, to_date) do
    case {NaiveDateTime.compare(complete_date, from_date),
          NaiveDateTime.compare(complete_date, to_date)} do
      {:lt, :lt} -> "Booking out of the interval"
      {:gt, :gt} -> "Booking out of the interval"
      {_, _} -> booking
    end
  end

  defp stringfy_booking(%Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
