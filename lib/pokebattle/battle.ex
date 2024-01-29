defmodule Pokebattle.Battle do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :p1, :p2, :winner]}
  schema "battles" do
    field :p1, :string
    field :p2, :string
    field :winner, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(battle, attrs) do
    battle
    |> cast(attrs, [:p1, :p2, :winner])
    |> validate_required([:p1, :p2, :winner])
  end

  def get_winner(p1, p2) do
    [p1, p2]
    |> Enum.at((1..2 |> Enum.random()) - 1)
  end

  def get_pokemon_info(pokemon) do
    {:ok, info} = case "https://pokeapi.co/api/v2/pokemon/#{pokemon}" |> HTTPoison.get() do
      {:ok, %{status_code: 200, body: body}} -> Jason.decode(body)
      {:ok, response} -> Jason.decode(response.body)
      error -> Logger.error("API error: #{inspect error}")
    end

    info
  end
end
