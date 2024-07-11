defmodule Hoa.Directory.Person.Query do
  import Ecto.Query
  alias Hoa.Directory.Person

  defp base, do: Person
  def all(query \\ base()) do
    query
    |> preload(:homes)
  end
  def where_id(query \\ base(), id) do
    query
    |> where(id: ^id)
    |> preload(:homes)
  end

  # def search(query \\ base() \\ base(), opts \\ []) do
  #   srch_params = Keyword.get(opts, :srch_params, [])
  #   query
  #   |> where(^srch_params)
  # end
end
