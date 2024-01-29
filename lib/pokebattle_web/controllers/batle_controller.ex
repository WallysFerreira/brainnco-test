defmodule PokebattleWeb.BattleController do
  use PokebattleWeb, :controller

  def receive_battle(conn, params) do
    p1 =
      params
      |> Map.get("p1")

    p2 =
      params
      |> Map.get("p2")

    show_info =
      params
      |> Map.get("show_info")

    {_, battle} = Pokebattle.Repo.insert(%Pokebattle.Battle{
      p1: p1,
      p2: p2,
      winner: Pokebattle.Battle.get_winner(p1, p2)
    })

    if show_info do
      json conn, %{
        p1: Pokebattle.Battle.get_pokemon_info(battle.p1),
        p2: Pokebattle.Battle.get_pokemon_info(battle.p2),
        winner: battle.winner
      }
    else
      json conn, battle
    end
  end
end
