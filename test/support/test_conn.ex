defmodule Hoa.TestConn do
  def checkout(_context \\ nil) do
    Ecto.Adapters.SQL.Sandbox.checkout(Hoa.Repo)
  end
end
