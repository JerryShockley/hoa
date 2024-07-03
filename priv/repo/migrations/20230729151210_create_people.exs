defmodule Hoa.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :middle_name, :string
      add :nickname, :string
      add :name_suffix, :string
      add :mobile_phone, :string
      add :work_phone, :string
      add :home_phone, :string
      add :email, :string
      add :mobile_phone_public, :boolean, default: false, null: false
      add :work_phone_public, :boolean, default: false, null: false
      add :home_phone_public, :boolean, default: false, null: false
      add :email_public, :boolean, default: false, null: false
      add :bio, :text
      add :dob, :date
      add :image_path, :string
      add :mail_addressee, :string
      add :street1, :string
      add :street2, :string
      add :city, :string
      add :state, :string
      add :postal_code, :string
      add :country_code, :string, default: "US"

      timestamps()
    end

    create unique_index(:people, [:email], name: :people_email_unique_index)
    create unique_index(:people, [:mobile_phone], name: :people_mobile_phone_unique_index)
  end
end
