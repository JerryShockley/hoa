defmodule Hoa.DirectoryTest do
  use Hoa.DataCase

  alias Hoa.Directory

  describe "homes" do
    alias Hoa.Directory.Home

    import Hoa.DirectoryFixtures

    @invalid_attrs %{home_name: nil, lot_number: nil, home_phone: nil,
      home_phone_public: nil, rental: nil, addressee: nil, street1: nil,
      city: nil, state_code: nil, postal_code: nil, country_code: nil}

    test "list_homes/0 returns all homes" do
      home = home_fixture()
      assert Directory.list_homes() == [home]
    end

    test "get_home!/1 returns the home with given id" do
      home = home_fixture()
      assert Directory.get_home!(home.id) == home
    end

    test "create_home/1 with valid data creates a home" do
      valid_attrs = %{home_name: "3812 NW 74th Ave",
        lot_number: "some lot_number", home_phone: "9906551234",
        home_phone_public: true, rental: true, addressee: "John Smith",
        street1: "345 Main Street", city: "Charlotte", state_code: "NC",
        postal_code: "28104"}

      assert {:ok, %Home{} = home} = Directory.create_home(valid_attrs)
      assert home.home_name == "3812 NW 74th Ave"
      assert home.lot_number == "some lot_number"
      assert home.home_phone ==  "9906551234"
      assert home.home_phone_public == true
      assert home.rental == true
      assert home.addressee == "John Smith"
      assert home.street1 == "345 Main Street"
      assert home.street2 == nil
      assert home.city == "Charlotte"
      assert home.state_code == "NC"
      assert home.postal_code == "28104"
      assert home.country_code == "US"
    end

    test "create_home/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_home(@invalid_attrs)
    end

    test "update_home/2 with valid data updates the home" do
      home = home_fixture()
      update_attrs = %{home_name: "3814 NW 74th Ave",
        lot_number: "some lot_number", home_phone: "2906551234",
        home_phone_public: true, rental: true, addressee: "Johnathon Smith",
        street1: "3459 Main Street", city: "Charlotte", state_code: "NC",
        postal_code: "28105"}

      assert {:ok, %Home{} = home} = Directory.update_home(home, update_attrs)
      assert home.home_name == "3814 NW 74th Ave"
      assert home.lot_number == "some lot_number"
      assert home.home_phone ==  "2906551234"
      assert home.home_phone_public == true
      assert home.rental == true
      assert home.addressee == "Johnathon Smith"
      assert home.street1 == "3459 Main Street"
      assert home.city == "Charlotte"
      assert home.state_code == "NC"
      assert home.postal_code == "28105"
    end

    test "update_home/2 with invalid data returns error changeset" do
      home = home_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_home(home, @invalid_attrs)
      assert home == Directory.get_home!(home.id)
    end

    test "delete_home/1 deletes the home" do
      home = home_fixture()
      assert {:ok, %Home{}} = Directory.delete_home(home)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_home!(home.id) end
    end

    test "change_home/1 returns a home changeset" do
      home = home_fixture()
      assert %Ecto.Changeset{} = Directory.change_home(home)
    end
  end

  describe "people" do
    alias Hoa.Directory.Person

    import Hoa.DirectoryFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, mobile_phone: nil, email: nil,
      mobile_phone_public: false, email_public: false, bio: nil, dob: nil,
      home_relationship: :owner, work_phone_public: false, image_path: nil,
      work_phone: "sfgfsagsdfg"}

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Directory.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Directory.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name",
        mobile_phone: "4438711233", email: "sam@gmail.com", mobile_phone_public: true,
        email_public: true, bio: "some bio", dob: ~D[2023-07-28],
        home_relationship: :owner, image_path: "some image_path",
        work_phone: "988-743-0021", work_phone_public: true}

      assert {:ok, %Person{} = person} = Directory.create_person(valid_attrs)
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.mobile_phone == "4438711233"
      assert person.work_phone == "9887430021"
      assert person.email == "sam@gmail.com"
      assert person.mobile_phone_public == true
      assert person.work_phone_public == true
      assert person.email_public == true
      assert person.bio == "some bio"
      assert person.dob == ~D[2023-07-28]
      assert person.home_relationship == :owner
      assert person.image_path == "some image_path"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name",
        mobile_phone: "9235568764", email: "youngsam@gmail.com", mobile_phone_public: false,
        email_public: false, bio: "some updated bio", dob: ~D[2023-07-29],
        home_relationship: :renter, image_path: "some updated image_path",
        work_phone: "644-743-4663", work_phone_public: false}

      assert {:ok, %Person{} = person} = Directory.update_person(person, update_attrs)
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
      assert person.mobile_phone == "9235568764"
      assert person.work_phone == "6447434663"
      assert person.email == "youngsam@gmail.com"
      assert person.mobile_phone_public == false
      assert person.work_phone_public == false
      assert person.email_public == false
      assert person.bio == "some updated bio"
      assert person.dob == ~D[2023-07-29]
      assert person.home_relationship == :renter
      assert person.image_path == "some updated image_path"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_person(person, @invalid_attrs)
      assert person == Directory.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Directory.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Directory.change_person(person)
    end
  end

  describe "pets" do
    alias Hoa.Directory.Pet

    import Hoa.DirectoryFixtures

    @invalid_attrs %{name: nil, type: nil, breed: nil, image_path: nil}

    test "list_pets/0 returns all pets" do
      pet = pet_fixture()
      assert Directory.list_pets() == [pet]
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Directory.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_attrs = %{name: "some name", type: :dog, breed: "some breed", image_path: "some image_path"}

      assert {:ok, %Pet{} = pet} = Directory.create_pet(valid_attrs)
      assert pet.name == "some name"
      assert pet.type == :dog
      assert pet.breed == "some breed"
      assert pet.image_path == "some image_path"
    end

    test "create_pet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_pet(@invalid_attrs)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = pet_fixture()
      update_attrs = %{name: "some updated name", type: :cat, breed: "some updated breed", image_path: "some updated image_path"}

      assert {:ok, %Pet{} = pet} = Directory.update_pet(pet, update_attrs)
      assert pet.name == "some updated name"
      assert pet.type == :cat
      assert pet.breed == "some updated breed"
      assert pet.image_path == "some updated image_path"
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = pet_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_pet(pet, @invalid_attrs)
      assert pet == Directory.get_pet!(pet.id)
    end

    test "delete_pet/1 deletes the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{}} = Directory.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_pet!(pet.id) end
    end

    test "change_pet/1 returns a pet changeset" do
      pet = pet_fixture()
      assert %Ecto.Changeset{} = Directory.change_pet(pet)
    end
  end
end
