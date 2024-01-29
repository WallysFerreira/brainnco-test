defmodule PokebattleWeb.BattleControllerTest do
  use PokebattleWeb.ConnCase, async: true

  describe "POST /api/battle" do
    test "without body", %{conn: conn} do
      conn = post(conn, ~p"/api/battle")

      assert conn.status == 400
      assert conn.resp_body == nil
    end

    test "without extra info", %{conn: conn} do
      request_body = %{
        pokemon1: "ditto",
        pokemon2: "bulbasaur",
        extra_info: false,
      }
      conn = post(conn, ~p"/api/battle", request_body)

      {:ok, resp_body} = Jason.decode(conn.resp_body)

      assert conn.status == 200
      assert Map.has_key?(resp_body, "id")
      assert Map.has_key?(resp_body, "winner")
      assert Map.get(resp_body, "pokemon1") == "ditto"
      assert Map.get(resp_body, "pokemon2") == "bulbasaur"
    end
  end
end
