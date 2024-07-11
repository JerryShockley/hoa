defmodule Hoa.DirectoryTest do
  use Hoa.DataCase
  # import Hoa.TestConn
  alias Hoa.DirectoryFixtures, as: Fixture
  alias Hoa.Directory

    def setup() do
      Ecto.Adapters.SQL.Sandbox.checkout(Hoa.Repo)
    end


  describe "homes" do
    alias Hoa.Directory.Home
    test "list_homes/0 returns all homes with nested" do
      home =  Fixture.home_fixture_with_nested()
      home1 = hd Directory.list_homes()
      assert home1 == home
    end

    test "get_home!/2 returns the home (inclusive nested) with given id" do
      home = Fixture.home_fixture_with_nested()
      home1 = Directory.get_home!(home.id)
      assert  home == home1
    end

    test "create_home/1 with valid data creates a home" do
      valid_params = Fixture.home_map()
      assert {:ok, %Home{}} = Directory.create_home(valid_params)
    end

    test "create_home/1 with invalid data returns error changeset" do
      invalid_params = Fixture.home_map(%{home_name: nil})
      assert {:error, %Ecto.Changeset{}} = Directory.create_home(invalid_params)
    end

    test "update_home/2 with valid data updates the home" do
      home = Fixture.home_fixture()
      update_params = Fixture.home_map()
      assert {:ok, %Home{}} = Directory.update_home(home, update_params)
    end

    test "update_home/2 with invalid data returns error changeset" do
      home = Fixture.home_fixture()
      invalid_params = Fixture.home_map(%{home_name: nil})
      assert {:error, %Ecto.Changeset{}} = Directory.update_home(home, invalid_params)
    end

    test "delete_home/1 deletes the home" do
      home = Fixture.home_fixture()
      assert {:ok, %Home{}} = Directory.delete_home(home)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_home!(home.id) end
    end

    test "changeset/1 returns a home changeset" do
      home = Fixture.home_fixture()
      assert %Ecto.Changeset{} = Home.changeset(home)
    end
  end

  describe "people" do
    alias Hoa.Directory.Person

    test "list_people/0 returns all people with nested homes" do
      person = Fixture.person_fixture_with_nested()
      person1 = hd Directory.list_people()
      assert person1 == person
    end

    test "get_person!/1 returns the person (with nested) with given id" do
      person = Fixture.person_fixture_with_nested()
      person1 = Directory.get_person!(person.id)
      assert person1 == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_params = Fixture.person_map()
      assert {:ok, %Person{}} = Directory.create_person(valid_params)
    end

    test "create_person/1 with invalid data returns error changeset" do
      invalid_params = Fixture.person_map(%{first_name: nil})
      assert {:error, %Ecto.Changeset{}} = Directory.create_person(invalid_params)
    end

    test "update_person/2 with valid data updates the person" do
      person = Fixture.person_fixture()
      update_params = Fixture.person_map()
      assert {:ok, %Person{}} = Directory.update_person(person, update_params)
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = Fixture.person_fixture()
      invalid_params = Fixture.person_map(%{first_name: nil})
      assert {:error, %Ecto.Changeset{}} = Directory.update_person(person, invalid_params)
    end

    test "delete_person/1 deletes the person" do
      person = Fixture.person_fixture()
      assert {:ok, %Person{}} = Directory.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_person!(person.id) end
    end

    test "changeset/1 returns a person changeset" do
      person = Fixture.person_fixture()
      assert %Ecto.Changeset{} = Person.changeset(person)
    end
  end

  describe "pets" do
    alias Hoa.Directory.Pet

    test "list_pets/0 returns all pets with nested" do
      pet = Fixture.pet_fixture_with_nested()
      [pet1 | _] = Directory.list_pets()
      assert pet == pet1
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = Fixture.pet_fixture_with_nested()
      pet1 = Directory.get_pet!(pet.id)
      assert pet1 == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_params = Fixture.pet_map_with_nested()
      assert {:ok, %Pet{}} = Directory.create_pet(valid_params)
    end

    test "create_pet/1 with invalid data returns error changeset" do
      invalid_params = Fixture.pet_map_with_nested(%{name: nil})
      assert {:error, %Ecto.Changeset{}} = Directory.create_pet(invalid_params)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = Fixture.pet_fixture()
      update_params = Fixture.pet_map()
      assert {:ok, %Pet{}} = Directory.update_pet(pet, update_params)
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = Fixture.pet_fixture()
      invalid_params = %{name: nil}
      assert {:error, %Ecto.Changeset{}} = Directory.update_pet(pet, invalid_params)
    end

    test "delete_pet/1 deletes the pet" do
      pet = Fixture.pet_fixture()
      assert {:ok, %Pet{}} = Directory.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_pet!(pet.id) end
    end

    test "changeset/1 returns a pet changeset" do
      pet = Fixture.pet_fixture()
      assert %Ecto.Changeset{} = Pet.changeset(pet)
    end
  end
end
