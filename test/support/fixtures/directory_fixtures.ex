defmodule Hoa.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Directory` context.
  """
  import Ecto.Changeset
  alias Hoa.Repo
  alias Hoa.Directory.{Home, Person, Pet}

  @pet_coloring [
    "Auburn", "black", "white", "tan", "copper", "gold", "brown",
    "black and white", "black and tan", "black, tan, and white"
   ]

  def home_map_with_nested(params \\ %{}) do
    home_map()
    |> Map.merge(params)
    |> Map.put(:people, random_people_map())
    |> Map.put(:pets, random_pet_map())
  end

  defp random_pet_map do
    for _i <- 0..random_pet_cnt() do
      pet_map()
    end
  end

  defp random_people_map do
    for _i <- 0..2 do
      person_map()
    end
  end


  def home_fixture_with_nested(params \\ %{}) do
    %Home{}
    |> cast(home_map_with_nested(), Home.fields(:all))
    |> cast(params, Home.fields(:all))
    |> cast_assoc(:people)
    |> cast_assoc(:pets)
    |> Repo.insert!

  end

  def home_map(params \\ %{}) do
    %{
        home_name: Faker.Address.street_address(),
        lot_number: to_string(Faker.random_between(1, 2378)),
        rental: random_true_false()
      }
      |> Map.merge(params)
  end

  def home_keys() do
    Map.keys(home_map())
  end

  @doc """
  Generate a home.
  """

  def home_fixture(params \\ %{}) do
      %Home{}
      |> cast(home_map(), Home.fields(:all))
      |> cast(params, Home.fields(:all))
      |> Repo.insert!
  end

  def person_map(params \\ %{}) do
    fname = Faker.Person.En.first_name()
    lname = Faker.Person.En.last_name()
    house_number = Faker.Address.En.building_number()
    street_name = Faker.Address.En.street_name()

    %{
      first_name: fname,
      middle_name: Faker.Person.En.first_name(),
      last_name: lname,
      nickname: random_nickname(),
      name_suffix: random_name_suffix(),
      mobile_phone: unformat_phone_number(Faker.Phone.EnUs.phone()),
      mobile_phone_public: random_true_false(),
      work_phone: unformat_phone_number(Faker.Phone.EnUs.phone()),
      work_phone_public: random_true_false(),
      home_phone: unformat_phone_number(Faker.Phone.EnUs.phone()),
      home_phone_public: random_true_false(),
      email: random_email(lname, fname),
      email_public: random_true_false(),
      mail_addressee: nil,
      street1: "#{house_number} #{street_name}",
      street2: nil,
      city: Faker.Address.En.city(),
      state: Faker.Address.En.state_abbr(),
      postal_code: Faker.Address.En.zip_code(),
      country_code: "US",
      bio: "some bio",
      dob: Faker.Date.date_of_birth(),
      home_relationship: :owner,
      image_path: random_avatar_image()
    }
    |> Map.merge(params)

  end

  def person_map_with_nested(params \\ %{}) do
    person_map()
    |> Map.merge(params)
    |> Map.put(:homes, [home_map()])
  end

  def person_keys() do
    Map.keys(person_map())
  end

  @doc """
  Generate a person.
  """
  def person_fixture(params \\ %{}) do
      %Person{}
      |> cast(person_map(), Person.fields(:all))
      |> cast(params, Person.fields(:all))
      |> Repo.insert!
  end

  def person_fixture_with_nested(params \\ %{}) do
      %Person{}
      |> cast(person_map_with_nested(), Person.fields(:all))
      |> cast(params, Person.fields(:all))
      |> cast_assoc(:homes)
      |> Repo.insert!
  end

  def pet_map(params \\ %{}) do
    %{
      name: Faker.Dog.PtBr.name(),
      type: :dog,
      breed: Faker.Dog.PtBr.breed(),
      coloring: Enum.random(@pet_coloring),
      dob: Faker.Date.date_of_birth(1..17),
      weight: Faker.random_between(6, 75),
      image_path: random_pet_avatar_image()
      }
    |> Map.merge(params)
  end

  def pet_map_with_nested(params \\ %{}) do
    pet_map()
    |> Map.merge(params)
    |> Map.put(:home, home_map())
  end

  def pet_keys() do
    Map.keys(pet_map())
  end

  @doc """
  Generate a pet.
  """
  def pet_fixture(params \\ %{}) do
     %Pet{}
      |> cast(pet_map(), Pet.fields(:all))
      |> cast(params, Pet.fields(:all))
      |> Repo.insert!
  end

  def pet_fixture_with_nested(params \\ %{}) do
    %Pet{}
    |> cast(pet_map_with_nested(), Pet.fields(:all))
    |> cast(params, Pet.fields(:all))
    |> cast_assoc(:home)
    |> Repo.insert!
  end

  defp random_email(lname, fname) do
    "#{fname}.#{lname}@#{Faker.Internet.En.free_email_service()}"
  end

  defp random_nickname() do
    case Faker.random_between(0, 40) do
      0 -> "Jr"
      1 -> "Dude"
      2 -> "JD"
      3 -> "Mick"
      4 -> "Jo"
      5 -> "Al"
      6 -> "Biggie"
      _ -> nil
    end
  end

  defp random_name_suffix() do
    case Faker.random_between(0, 40) do
      0 -> "Jr."
      1 -> "Sr."
      2 -> "MD"
      3 -> "I"
      4 -> "II"
      5 -> "III"
      6 -> "PhD"
      _ -> nil
    end
  end

  defp random_true_false() do
    elem({true, false}, Faker.random_between(0, 1))
  end

  defp random_avatar_image() do
    avatars = [
      "adult-18086_640.jpg",
      "girl-2099363_640.jpg",
      "man-2442565_640.jpg",
      "portrait-3353699_640.jpg",
      "woman-597173_640.jpg",
      "asian-3767281_640.jpg",
      "girl-2961959_640.jpg",
      "man-351281_640.jpg",
      "summer-3136374_640.jpg",
      "young-man-1281282_640.jpg",
      "beard-1845166_640.jpg",
      "girl-6093779_640.jpg",
      "man-930397_640.jpg",
      "woman-1284411_640.jpg",
      "beautiful-girl-2003650_640.jpg",
      "human-3782189_640.jpg",
      "people-875597_640.jpg",
      "woman-2349048_640.jpg",
      "call-15924_640.jpg",
      "male-2634974_640.jpg",
      "portrait-2194457_640.jpg",
      "woman-2563491_640.jpg",
      "face-5084530_640.jpg",
      "man-1485335_640.jpg",
      "portrait-3190849_640.jpg",
      "woman-3289372_640.jpg"
    ]

    [image_path | []] = Enum.take_random(avatars, 1)
    image_path
  end

  defp random_pet_avatar_image() do
    pet_avatars = [
      "dachshund-1519374_640.jpg",
      "dog-3277416_640.jpg",
      "puppy-1047521_640.jpg",
      "puppy-2785074_640.jpg",
      "dalmatian-1020790_640.jpg",
      "labrador-retriever-1210559_640.jpg",
      "puppy-1207816_640.jpg"
    ]

    [image_path | []] = Enum.take_random(pet_avatars, 1)
    image_path
  end

  defp random_pet_cnt() do
    odds = [0, 1, 0, 0, 0, 1, 0, 2, 0, 0, 1, 0, 0, 0]
    [cnt | []] = Enum.take_random(odds, 1)
    cnt
  end

  defp unformat_phone_number(phone_str) do
    String.replace(phone_str, ~r/[\.\(\)\-\s\/]/, "")
  end
end
