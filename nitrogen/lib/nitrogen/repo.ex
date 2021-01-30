defmodule Nitrogen.Repo do
  use Ecto.Repo,
    otp_app: :nitrogen,
    adapter: Ecto.Adapters.Postgres
end
