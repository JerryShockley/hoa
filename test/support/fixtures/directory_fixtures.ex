defmodule Hoa.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hoa.Directory` context.
  """

  @doc """
  Generate a home.
  """
  def home_fixture(attrs \\ %{}) do
    {:ok, home} =
      attrs
      |> Enum.into(%{
        home_name: "3814 NW 77th Ave",
        lot_number: "some lot_number",
        home_phone: "7043668323",
        home_phone_public: true,
        rental: false,
        state_code: "some state",
        postal_code: "some zip",
        addressee: "some addressee",
        street1: "some street1",
        street2: "some street2",
        city: "some city",
        country_code: "some country",
      })
      |> Hoa.Directory.create_home()

    home
  end

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        mobile_phone: "9028779933",
        work_phone: "6418987017",
        email: "some@email.com",
        mobile_phone_public: true,
        work_phone_public: true,
        email_public: true,
        bio: "some bio",
        dob: ~D[1984-07-28],
        home_relationship: :owner,
        image_path: nil
      })
      |> Hoa.Directory.create_person()

    person
  end

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    {:ok, pet} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: :dog,
        breed: "some breed",
        dob: ~D[2023-02-02],
        weight: 18,
        image_path: nil
      })
      |> Hoa.Directory.create_pet()

    pet
  end
end
