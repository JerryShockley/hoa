defmodule Hoa.Directory.Person do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Hoa.Directory.Home
  alias Hoa.Directory.HomePerson
  import Date
  import Utils.CustomValidations

  schema "people" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :nickname, :string
    field :name_suffix, :string
    field :mobile_phone, :string
    field :work_phone, :string
    field :home_phone, :string
    field :email, :string
    field :mobile_phone_public, :boolean, default: false
    field :work_phone_public, :boolean, default: false
    field :home_phone_public, :boolean, default: false
    field :email_public, :boolean, default: false
    field :bio, :string
    field :dob, :date
    field :home_relationship, Ecto.Enum, values: [:owner, :renter, :child, :other]
    field :image_path, :string
    field :mail_addressee, :string
    field :street1, :string
    field :street2, :string
    field :city, :string
    field :state, :string
    field :postal_code, :string
    field :country_code, :string, default: "US"
    many_to_many(:homes, Home, join_through: HomePerson)

    timestamps()
  end

  @doc false
  def changeset(person, params \\ %{}) do
    person
    |> cast(params, [
      :first_name,
      :last_name,
      :middle_name,
      :nickname,
      :name_suffix,
      :mobile_phone,
      :mobile_phone_public,
      :work_phone,
      :work_phone_public,
      :home_phone,
      :home_phone_public,
      :email,
      :email_public,
      :bio,
      :dob,
      :home_relationship,
      :image_path,
      :mail_addressee,
      :street1,
      :street2,
      :city,
      :state,
      :postal_code,
      :country_code
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :home_relationship
    ])
    |> update_change(:mobile_phone, &remove_phone_formatting/1)
    |> update_change(:work_phone, &remove_phone_formatting/1)
    |> update_change(:home_phone, &remove_phone_formatting/1)
    |> validate_length(:mobile_phone, is: 10)
    |> validate_length(:work_phone, is: 10)
    |> validate_length(:home_phone, is: 10)
    |> validate_format(
      :email,
      ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    )
    |> unique_constraint(:mobile_phone)
    |> unique_constraint(:work_phone)
    |> unique_constraint(:home_phone)
    |> unique_constraint(:email)
    |> validate_inclusion(:home_relationship, [:owner, :renter, :child, :other])
    |> validate_date_in_range(:dob, ~D[1900-01-01], utc_today())
    |> cast_assoc(:homes, with: &Hoa.Directory.Home.changeset/2)
  end

  def remove_phone_formatting(phone_str) when byte_size(phone_str) > 0 do
    String.replace(phone_str, ~r/[^0-9]/, "")
  end

  def remove_phone_formatting(_phone_str), do: nil

  defp base do
    from _ in Hoa.Directory.Person, as: :person
  end


  def all(query \\ base()) do
    query
    |> with_homes()
  end


  def where_id(query \\ base(), id) do
    from e in query,
      where: e.id == ^id
  end
  # def search(query \\ base() \\ base(), opts \\ []) do
  #   srch_params = Keyword.get(opts, :srch_params, [])
  #   query
  #   |> where(^srch_params)
  # end

  # defp apply_joins(query \\ base(), joins) do
  #   Enum.reduce(joins, query, fn e, q -> q |>
  #     join(:left, [h], p in assoc(h, :people))
  # end

  # defp apply_preloads(query \\ base() \\ base(), preloads) do
  #   query
  #   |> from()
  #   |> apply_joins()
  # end

  def with_homes(query \\ base()) do
    from e in query,
      join: h in assoc(e, :homes),
      preload: :homes
  end

  # def select_detail(query \\ base() \\ base()) do
  #   query
  #   |> from()
  #   |> select([p, h],
  #             [h.home_name,
  #             p.first_name,
  #             p.nickname,
  #             p.middle_name,
  #             p.last_name,
  #             p.name_suffix,
  #             p.home_phone,
  #             p.home_phone_public,
  #             p.work_phone,
  #             p.work_phone_public,
  #             p.mobile_phone,
  #             p.mobile_phone_public,
  #             p.email,
  #             p.email_public,
  #             p.bio,
  #             p.home_relationship,
  #             p.street1,
  #             p.street2,
  #             p.city,
  #             p.state,
  #             p.postal_code,
  #             p.country_code
  #           ]
  #             )
  # end

  # def select_list(query \\ base() \\ base()) do
  #   query
  #   |> from()
  #   |> select([p, h],
  #             [h.home_name,
  #             p.first_name,
  #             p.nickname,
  #             p.last_name,
  #             p.mobile_phone,
  #             p.email]
  #             )
  # end

end
