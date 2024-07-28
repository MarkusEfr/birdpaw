defmodule Birdpaw.Repo do
  use Ecto.Repo,
    otp_app: :birdpaw,
    adapter: Ecto.Adapters.Postgres
end
