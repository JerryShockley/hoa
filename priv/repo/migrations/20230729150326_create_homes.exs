defmodule Hoa.Repo.Migrations.CreateHomes do
  use Ecto.Migration

  def change do
    create table(:homes) do
      add :home_name , :string
      add :lot_number, :string
      add :home_phone, :string
      add :home_phone_public, :boolean, default: false, null: false
      add :rental, :boolean, default: false, null: false
      add :addressee, :string
      add :street1, :string
      add :street2, :string
      add :city, :string
      add :state_code, :string
      add :postal_code, :string
      add :country_code, :string, default: "US"

      timestamps()
    end
  end
end
