defmodule PokebattleWeb.BattleController do
  use PokebattleWeb, :controller

  def create(conn, params) do
    case Enum.empty?(params) do
      true ->  put_status(conn, 400)
      false -> json conn, %{}
    end

  end
end
