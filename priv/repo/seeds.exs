# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hoa.Repo.insert!(%Hoa.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if soomething goes wrong.
alias Hoa.DirectoryFixtures, as: Fixture
Faker.start()
Code.require_file("test/support/fixtures/directory_fixtures.ex")

defmodule Seeds do
  alias Hoa.Accounts
  use Ecto.Schema
  import Ecto.Query, warn: false

  def save_user_records do
    users = [
      %{email: "jerry1@shockleynet.com", password: "hello11111"},
      %{email: "noise1@shockleynet.com", password: "hello11111"}
    ]

    Enum.each(users, fn user -> Accounts.register_user(user) end)
  end
end

Seeds.save_user_records()
for _i <- 1..100, do: Fixture.home_fixture_with_nested()
