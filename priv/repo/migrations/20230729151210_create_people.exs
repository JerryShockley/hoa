defmodule Hoa.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :middle_name, :string
      add :nickname, :string
      add :mobile_phone, :string
      add :work_phone, :string
      add :email, :string
      add :mobile_phone_public, :boolean, default: false, null: false
      add :work_phone_public, :boolean, default: false, null: false
      add :email_public, :boolean, default: false, null: false
      add :bio, :text
      add :dob, :date
      add :home_relationship, :string, null: false
      add :image_path, :string
      add :home_id, references(:homes, on_delete: :delete_all)

      timestamps()
    end

    create index(:people, [:home_id])
    create index(:people, [:email])
  end
end
