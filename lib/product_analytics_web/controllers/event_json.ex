defmodule ProductAnalyticsWeb.EventJSON do
  alias ProductAnalytics.Events.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      user_id: event.user_id,
      event_time: event.event_time,
      event_name: event.event_name,
      attributes: event.attributes
    }
  end
end
