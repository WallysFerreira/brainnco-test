defmodule PokebattleWeb.BattleControllerTest do
  describe "POST /api/battle" do
    test "without body", %{conn: conn} do
      conn = post(conn, ~p"/api/battle")

      assert conn.status == 400
      assert conn.resp_body == nil
    end
  end
end
