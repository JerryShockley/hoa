defmodule Hoa.Repo.Migrations.CreateHomes do
  use Ecto.Migration

  def change do
    create table(:homes) do
      add :home_name, :string
      add :lot_number, :string
      add :rental, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:homes, [:home_name])
  end
end
