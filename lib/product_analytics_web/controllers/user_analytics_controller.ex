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

  defp format_event(%{user_id: user_id, last_event_at: last_event_at, event_count: event_count}) do
    %{
      user_id: user_id,
      last_event_at: last_event_at,
      event_count: event_count
    }
  end
end
