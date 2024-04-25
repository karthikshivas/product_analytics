defmodule ProductAnalytics.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ProductAnalytics.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        attributes: %{},
        event_name: "some event_name",
        event_time: ~U[2024-04-24 07:35:00Z],
        user_id: "some user_id"
      })
      |> ProductAnalytics.Events.create_event()

    event
  end
end
