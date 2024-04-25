defmodule ProductAnalytics.EventsTest do
  use ProductAnalytics.DataCase

  alias ProductAnalytics.Events

  describe "events" do
    alias ProductAnalytics.Events.Event

    import ProductAnalytics.EventsFixtures

    @invalid_attrs %{attributes: nil, user_id: nil, event_time: nil, event_name: nil}

    test "valid changeset" do
      attrs = %{
        user_id: "user1",
        event_name: "subscription_activated",
        attributes: %{"plan" => "pro", "billing_interval" => "year"}
      }

      changeset = Event.changeset(%Event{}, attrs)

      assert changeset.valid?
    end

    test "changeset with missing parameters" do
      attrs = %{
        event_name: "subscription_activated",
        attributes: %{"plan" => "pro", "billing_interval" => "year"}
      }

      changeset = Event.changeset(%Event{}, attrs)
      assert changeset.errors != []
    end

    #   test "list_events/0 returns all events" do
    #     event = event_fixture()
    #     assert Events.list_events() == [event]
    #   end

    #   test "get_event!/1 returns the event with given id" do
    #     event = event_fixture()
    #     assert Events.get_event!(event.id) == event
    #   end

    test "create_event/1 with valid data creates a event" do
      random_number = :rand.uniform(1000) + 1
      random_user_id = "user_#{random_number}"
      random_event = random_event()

      valid_attrs = %{
        attributes: %{},
        user_id: random_user_id,
        event_time: ~U[2024-04-24 07:35:00Z],
        event_name: random_event
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.attributes == %{}
      assert event.user_id == random_user_id
      assert event.event_time == ~U[2024-04-24 07:35:00Z]
      assert event.event_name == random_event
    end

    #   test "create_event/1 with invalid data returns error changeset" do
    #     assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    #   end

    #   test "update_event/2 with valid data updates the event" do
    #     event = event_fixture()

    #     update_attrs = %{
    #       attributes: %{},
    #       user_id: "some updated user_id",
    #       event_time: ~U[2024-04-25 07:35:00Z],
    #       event_name: "some updated event_name"
    #     }

    #     assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
    #     assert event.attributes == %{}
    #     assert event.user_id == "some updated user_id"
    #     assert event.event_time == ~U[2024-04-25 07:35:00Z]
    #     assert event.event_name == "some updated event_name"
    #   end

    #   test "update_event/2 with invalid data returns error changeset" do
    #     event = event_fixture()
    #     assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
    #     assert event == Events.get_event!(event.id)
    #   end

    #   test "delete_event/1 deletes the event" do
    #     event = event_fixture()
    #     assert {:ok, %Event{}} = Events.delete_event(event)
    #     assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    #   end

    #   test "change_event/1 returns a event changeset" do
    #     event = event_fixture()
    #     assert %Ecto.Changeset{} = Events.change_event(event)
    #   end

    defp random_event() do
      event_list = ["login", "logout", "subscription_activated", "unsubscribed"]
      Enum.random(event_list)
    end
  end
end
