defmodule Pokebattle.Repo do
  use Ecto.Repo,
    otp_app: :pokebattle,
    adapter: Ecto.Adapters.Postgres
end
