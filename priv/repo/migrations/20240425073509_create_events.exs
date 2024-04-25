defmodule ProductAnalytics.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :event_time, :utc_datetime
      add :event_name, :string
      add :attributes, :map

      timestamps(type: :utc_datetime)
    end
  end
end
