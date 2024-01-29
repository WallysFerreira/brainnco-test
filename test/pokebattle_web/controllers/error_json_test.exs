defmodule PokebattleWeb.ErrorJSONTest do
  use PokebattleWeb.ConnCase, async: true

  test "renders 404" do
    assert PokebattleWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PokebattleWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  describe "POST /api/battle" do
    test "without body", %{conn: conn} do
      conn = post(conn, ~p"/api/battle")

      assert conn.status == 400
      assert conn.resp_body == nil
    end
  end
end
