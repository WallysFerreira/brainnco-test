defmodule PokebattleWeb.BattleControllerTest do
  use PokebattleWeb.ConnCase, async: true

  describe "POST /api/battle" do
    test "without body", %{conn: conn} do
      conn = post(conn, ~p"/api/battle")

      assert conn.status == 400
      assert conn.resp_body == nil
    end

    test "with inexistent pokemon", %{conn: conn} do
      request_body = %{
        pokemon1: "invalid",
        pokemon2: "pikachu",
        extra_info: false,
      }

      conn = post(conn, ~p"/api/battle", request_body)

      assert conn.status == 400
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

    test "with extra info", %{conn: conn} do
      request_body = %{
        pokemon1: "ditto",
        pokemon2: "bulbasaur",
        extra_info: true,
      }

      conn = post(conn, ~p"/api/battle", request_body)

      {:ok, resp_body} = Jason.decode(conn.resp_body)

      assert conn.status == 200
      assert Map.has_key?(resp_body, "id")
      assert Map.has_key?(resp_body, "winner")
      assert is_map(Map.get(resp_body, "pokemon1"))
      assert is_map(Map.get(resp_body, "pokemon2"))
      assert Map.get(Map.get(resp_body, "pokemon1"), "name") == "ditto"
      assert Map.get(Map.get(resp_body, "pokemon2"), "name") == "bulbasaur"
    end
  end

  test "GET /api/battle", %{conn: conn} do
    conn = post(conn, ~p"/api/battle", %{
      pokemon1: "ditto",
      pokemon2: "bulbasaur",
      extra_info: false
    })

    conn = get(conn, ~p"/api/battle")
    {:ok, resp_body} = Jason.decode(conn.resp_body)

    assert conn.status == 200
    assert is_list(resp_body)
    assert length(resp_body) > 0
  end

  describe "GET /api/battle/id" do
    test "with valid id", %{conn: conn} do
      request_body = %{
        pokemon1: "ditto",
        pokemon2: "bulbasaur",
        extra_info: false,
      }
      conn = post(conn, ~p"/api/battle", request_body)
      {:ok, post_resp_body} = Jason.decode(conn.resp_body)

      conn = get(conn, ~p"/api/battle/#{Map.get(post_resp_body, "id")}")
      {:ok, resp_body} = Jason.decode(conn.resp_body)

      assert conn.status == 200
      assert is_map(resp_body)
      assert Map.get(resp_body, "id") == Map.get(post_resp_body, "id")
      assert Map.get(resp_body, "pokemon1") == request_body.pokemon1
      assert Map.get(resp_body, "pokemon2") == request_body.pokemon2
    end
  end

  test "with invalid id", %{conn: conn} do
      conn = get(conn, ~p"/api/battle/300")

      assert conn.status == 404
  end
end
