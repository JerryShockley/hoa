defmodule Hoa.Directory.Home.Query do
  import Ecto.Query
  alias Hoa.Directory.Home

  defp base, do: Home

  def all(query \\ base()) do
    query
    |> preload([:people, :pets])
  end

  @spec where_id(any(), any()) :: any()
  def where_id(query \\ base(), id) do
    query
    |> where(id: ^id)
    |> preload([:people, :pets])
  end

  def search(query \\ base(), opts \\ []) do
    srch_params = Keyword.get(opts, :srch_params, [])
      from e in query,
      where: ^srch_params
  end

  # def with_people(query \\ base()) do
  #   from e in query,
  #     join: p in assoc(e, :people),
  #     preload: [people: p]
  # end

  # def with_pets(query \\ base()) do
  #   from e in query,
  #     join: t in assoc(e, :pets),
  #     preload: [pets: t]
  # end
end
