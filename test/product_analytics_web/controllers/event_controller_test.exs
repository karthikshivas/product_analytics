defmodule ProductAnalyticsWeb.EventControllerTest do
  use ProductAnalyticsWeb.ConnCase

  import ProductAnalytics.EventsFixtures

  alias ProductAnalytics.Events.Event

  @create_attrs %{
    attributes: %{},
    user_id: "some user_id",
    event_time: ~U[2024-04-24 07:35:00Z],
    event_name: "some event_name"
  }
  @update_attrs %{
    attributes: %{},
    user_id: "some updated user_id",
    event_time: ~U[2024-04-25 07:35:00Z],
    event_name: "some updated event_name"
  }
  @invalid_attrs %{attributes: nil, user_id: nil, event_time: nil, event_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "attributes" => %{},
               "event_name" => "some event_name",
               "event_time" => "2024-04-24T07:35:00Z",
               "user_id" => "some user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "attributes" => %{},
               "event_name" => "some updated event_name",
               "event_time" => "2024-04-25T07:35:00Z",
               "user_id" => "some updated user_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
