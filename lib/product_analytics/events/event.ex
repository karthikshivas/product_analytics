defmodule ProductAnalytics.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  # import Timex

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :attributes, :map
    field :user_id, :string
    field :event_time, :utc_datetime
    field :event_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:user_id, :event_time, :event_name, :attributes])
    |> validate_required([:user_id, :event_name, :attributes])
    |> validate_format(:user_id, ~r/^[a-zA-Z0-9_]+$/,
      message: "must contain only letters, numbers, and underscores"
    )
    |> validate_length(:user_id, max: 50)
    |> validate_inclusion(
      :event_name,
      ["login", "logout", "subscription_activated", "unsubscribed"],
      message: "invalid event name"
    )
    |> handle_event_time()
  end

  defp handle_event_time(changeset) do
    case get_change(changeset, :event_time) do
      x when x == nil or x == "" ->
        date = DateTime.utc_now() |> DateTime.truncate(:second)
        put_change(changeset, :event_time, date)

      _event_time ->
        changeset
    end
  end
end
