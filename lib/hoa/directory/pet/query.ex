defmodule Hoa.Directory.Pet.Query do
  import Ecto.Query
  alias Hoa.Directory.Pet

  defp base, do: Pet
  def all(query \\ base()) do
    query
    |> preload([:home])
  end
  def where_id(query \\ base(), id) do
    query
    |> where(id: ^id)
    |> preload([:home])
  end
  # def search(query \\ base() \\ base(), opts \\ []) do
  #   srch_params = Keyword.get(opts, :srch_params, [])
  #   query
  #   |> where(^srch_params)
  # end
end
