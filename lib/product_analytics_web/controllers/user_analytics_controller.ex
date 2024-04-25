defmodule ProductAnalyticsWeb.UserAnalyticsController do
  use ProductAnalyticsWeb, :controller

  import Ecto.Query

  alias ProductAnalytics.Events.Event

  def index(conn, params) do
    IO.inspect(params, label: "params")
    event_name = Map.get(params, "event_name", nil)

    events_query =
      case is_nil(event_name) do
        true ->
          from(e in Event,
            group_by: e.user_id,
            select: %{
              user_id: e.user_id,
              last_event_at: max(e.event_time),
              event_count: count(e.id)
            },
            order_by: [desc: max(e.event_time)]
          )

        _ ->
          from(e in Event,
            where: ^event_name == e.event_name,
            group_by: e.user_id,
            select: %{
              user_id: e.user_id,
              last_event_at: max(e.event_time),
              event_count: count(e.id)
            },
            order_by: [desc: max(e.event_time)]
          )
      end

    events = ProductAnalytics.Repo.all(events_query)
    formatted_events = Enum.map(events, &format_event/1)

    conn
    |> put_status(:ok)
    |> json(%{data: formatted_events})
  end

  def event_analytics(conn, %{
        "from" => from_date_str,
        "to" => to_date_str,
        "event_name" => event_name
      }) do
    case {Date.from_iso8601(from_date_str), Date.from_iso8601(to_date_str)} do
      {{:ok, from_date}, {:ok, to_date}} ->
        events_query =
          case is_nil(event_name) do
            true ->
              from(e in Event,
                where: e.event_time >= ^from_date and e.event_time <= ^to_date,
                group_by: fragment("DATE(?)", e.event_time),
                select: %{
                  date: fragment("DATE(?)", e.event_time),
                  count: count(e.id),
                  unique_count: count(fragment("DISTINCT ?", e.user_id))
                },
                order_by: [asc: fragment("DATE(?)", e.event_time)]
              )

            _ ->
              from(e in Event,
                where:
                  e.event_time >= ^from_date and e.event_time <= ^to_date and
                    ^event_name == e.event_name,
                group_by: fragment("DATE(?)", e.event_time),
                select: %{
                  date: fragment("DATE(?)", e.event_time),
                  count: count(e.id),
                  unique_count: count(fragment("DISTINCT ?", e.user_id))
                },
                order_by: [asc: fragment("DATE(?)", e.event_time)]
              )
          end

        events = ProductAnalytics.Repo.all(events_query)
        formatted_events = Enum.map(events, &format_event_bydate/1)

        conn
        |> put_status(:ok)
        |> json(%{data: formatted_events})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid date format"})
    end
  end

  defp format_event_bydate(%{date: date, count: count, unique_count: unique_count}) do
    %{
      date: date,
      count: count,
      unique_count: unique_count
    }
  end

  defp format_event(%{user_id: user_id, last_event_at: last_event_at, event_count: event_count}) do
    %{
      user_id: user_id,
      last_event_at: last_event_at,
      event_count: event_count
    }
  end
end
