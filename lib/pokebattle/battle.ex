defmodule Pokebattle.Battle do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :pokemon1, :pokemon2, :winner]}
  schema "battles" do
    field :pokemon1, :string
    field :pokemon2, :string
    field :winner, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(battle, attrs) do
    battle
    |> cast(attrs, [:pokemon1, :pokemon2, :winner])
    |> validate_required([:pokemon1, :pokemon2, :winner])
  end

  def get_winner(p1, p2) do
    [p1, p2]
    |> Enum.at(Enum.random(1..2) - 1)
  end
end
