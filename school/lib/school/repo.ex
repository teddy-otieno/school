defmodule School.Repo do
  use Ecto.Repo,
    otp_app: :school,
    adapter: Ecto.Adapters.Postgres
end
