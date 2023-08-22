defmodule Hoa.Repo do
  use Ecto.Repo,
    otp_app: :hoa,
    adapter: Ecto.Adapters.Postgres
end
