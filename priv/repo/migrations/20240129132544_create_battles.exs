defmodule Pokebattle.Repo.Migrations.CreateBattles do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :pokemon1, :string
      add :pokemon2, :string
      add :winner, :string

      timestamps(type: :utc_datetime)
    end
  end
end
