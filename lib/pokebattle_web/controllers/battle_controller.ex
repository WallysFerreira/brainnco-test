defmodule PokebattleWeb.BattleController do
  use PokebattleWeb, :controller
  import Ecto.Query

  def create(conn, params) do
    case Enum.empty?(params) do
      true ->  conn |> resp(400, "no body sent") |> send_resp()
      false ->
        p1 =
          params
          |> Map.get("pokemon1")

        p2 =
          params
          |> Map.get("pokemon2")

        valid? =
          [p1, p2]
          |> Enum.map(&Pokebattle.Battle.validate_pokemon/1)
          |> Enum.all?()

        if !valid? do
          conn
          |> resp(400, "invalid pokemon name")
          |> send_resp()
        else
          {:ok, battle} =
            Pokebattle.Repo.insert(%Pokebattle.Battle{
              pokemon1: p1,
              pokemon2: p2,
              winner: Pokebattle.Battle.get_winner(p1, p2)
            })

          battle = if params |> Map.get("extra_info") do
            battle
            |> Map.update!(:pokemon1, fn pokemon_name ->
              Pokebattle.Battle.get_pokemon_info(pokemon_name)
            end)
            |> Map.update!(:pokemon2, fn pokemon_name ->
              Pokebattle.Battle.get_pokemon_info(pokemon_name)
            end)
          else
            battle
          end

          json conn, battle
        end
    end
  end

  def index(conn, _params) do
    battles =
      Pokebattle.Repo.all(Pokebattle.Battle)
      |> Enum.map(fn battle ->
        battle
        |> Map.update!(:pokemon1, &(Pokebattle.Battle.get_pokemon_info(&1)))
        |> Map.update!(:pokemon2, &(Pokebattle.Battle.get_pokemon_info(&1)))
      end)

    json conn, battles
  end

  def show(conn, %{"id" => id}) do
    found_battle = Pokebattle.Repo.one(from b in Pokebattle.Battle, where: b.id == ^id)

    if found_battle == nil do
      conn
      |> resp(404, "Not found")
      |> send_resp()
    else
      json conn, found_battle
    end
  end
end
