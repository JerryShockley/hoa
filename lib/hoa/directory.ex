defmodule Hoa.Directory do
  @moduledoc """
  The Directory context.
  """

  # import Ecto.Query
  alias Hoa.Repo
  # alias Hoa.Directory
  alias Hoa.Directory.{Home, Person, Pet}
  @doc """
  Returns the list of homes.

  ## Examples

      iex> list_homes()
      [%Home{}, ...]

  """
  def list_homes() do
    Home
    |> Home.Query.all()
    |> Repo.all()
  end

  @doc """
  Gets a single home.

  Raises `Ecto.NoResultsError` if the Home does not exist.

  ## Examples

      iex> get_home!(123)
      %Home{}

      iex> get_home!(456)
      ** (Ecto.NoResultsError)

  """
  def get_home!(id) do
    Home
    |> Home.Query.where_id(id)
    |> Repo.one!()
  end

  @doc """
  Creates a home.

  ## Examples

      iex> create_home(%{field: value})
      {:ok, %Home{}}

      iex> create_home(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_home(attrs \\ %{}) do
    %Home{}
      |> Home.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a home.

  ## Examples

      iex> update_home(home, %{field: new_value})
      {:ok, %Home{}}

      iex> update_home(home, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_home(%Home{} = home, attrs) do
    home
    |> Home.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a home.

  ## Examples

      iex> delete_home(home)
      {:ok, %Home{}}

      iex> delete_home(home)
      {:error, %Ecto.Changeset{}}

  """
  def delete_home(%Home{} = home) do
    Repo.delete(home)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking home changes.

  ## Examples

      iex> change_home(home)
      %Ecto.Changeset{data: %Home{}}

  """
  def change_home(%Home{} = home, attrs \\ %{}) do
    Home.changeset(home, attrs)
  end

  alias Hoa.Directory.Person

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%Person{}, ...]

  """
  def list_people() do
    Person
    |> Person.Query.all()
    |> Repo.all
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id) do
    Person
    |> Person.Query.where_id(id)
    |> Repo.one!()
  end

  @spec create_person(
          :invalid
          | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: any()
  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  alias Hoa.Directory.Pet

  @doc """
  Returns the list of pets.

  ## Examples

      iex> list_pets()
      [%Pet{}, ...]

  """
  def list_pets do
    Pet
    |> Pet.Query.all()
    |> Repo.all()
  end

  @doc """
  Gets a single pet.

  Raises `Ecto.NoResultsError` if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

      iex> get_pet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet!(id) do
    Pet
    |> Pet.Query.where_id(id)
    |> Repo.one!()
  end

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Ecto.Changeset{data: %Pet{}}

  """
  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end
end
