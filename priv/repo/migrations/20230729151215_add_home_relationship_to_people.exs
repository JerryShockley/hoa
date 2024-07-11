defmodule Hoa.Repo.Migrations.AddHomeRelationshipToPeople do
  @docp """
  This module is created to enable db level checking of valid enum values.
  The SQL commands used here are specific to the Postgresql database (PSQL)
  and as such requires the use of PSQL.
  """
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE home_relationship_type AS ENUM ('owner', 'renter', 'child', 'other')"
    drop_query = "DROP TYPE home_relationship_type"
    execute(create_query, drop_query)

    alter table(:people) do
      add :home_relationship, :home_relationship_type
    end
  end
end
