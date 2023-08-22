defmodule Hoa.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :type, :string
      add :breed, :string
      add :weight, :integer
      add :dob, :date
      add :image_path, :string
      add :home_id, references(:homes, on_delete: :delete_all)

      timestamps()
    end

    create index(:pets, [:home_id])
    create index(:pets, [:name])
  end
end
