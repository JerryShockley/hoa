defmodule Hoa.Directory.Pet do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  import Utils.CustomValidations
  alias Hoa.Directory.Home
  import Date

  schema "pets" do
    field :name, :string
    field :type, Ecto.Enum, values: [:dog, :cat]
    field :breed, :string
    field :dob, :date
    field :weight, :integer
    field :image_path, :string
    field :delete, :boolean, virtual: true
    belongs_to :home, Home

    timestamps()
  end

  @doc false
  def changeset(pet, params \\ %{}) do
    pet
    |> cast(params, field_names())
    |> validate_required([:name, :type, :breed])
    |> validate_number(:weight, greater_than: 0)
    |> validate_date_in_range(:dob, Date.add(utc_today(), -365 * 20), utc_today())
    |> cast_assoc(:home, with: &Hoa.Directory.Home.changeset/2)
  end

  def field_names(),  do: [:name, :type, :breed, :image_path, :dob, :weight, :delete]

  defp base() do
    from _ in Hoa.Directory.Pet, as: :pet
  end



  def all(query \\ base()), do: query


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
