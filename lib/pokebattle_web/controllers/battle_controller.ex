defmodule PokebattleWeb.BattleController do
  use PokebattleWeb, :controller

  def create(conn, params) do
    case Enum.empty?(params) do
      true ->  put_status(conn, 400)
      false ->
        p1 =
          params
          |> Map.get("pokemon1")

        p2 =
          params
          |> Map.get("pokemon2")

        {:ok, battle} =
          Pokebattle.Repo.insert(%Pokebattle.Battle{
            pokemon1: p1,
            pokemon2: p2,
            winner: Pokebattle.Battle.get_winner(p1, p2)
          })

        json conn, battle
    end
  end
end
