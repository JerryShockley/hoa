defmodule Hoa.Repo.Migrations.CreateHomesPeople do
  use Ecto.Migration

  def change do
    create table(:homes_people) do
      add :home_id, references(:homes, on_delete: :delete_all), null: false
      add :person_id, references(:people, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:homes_people, [:home_id])
    create index(:homes_people, [:person_id])
  end
end
