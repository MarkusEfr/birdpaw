defmodule BirdpawWeb.PresaleOrderControllerTest do
  use BirdpawWeb.ConnCase

  import Birdpaw.PresaleFixtures

  alias Birdpaw.Presale.PresaleOrder

  @create_attrs %{
    timestamp: ~U[2024-08-31 15:33:00Z],
    uuid: "some uuid",
    eth_address: "some eth_address",
    birdpaw_amount: 42,
    eth_amount: "120.5",
    payment_method: "some payment_method"
  }
  @update_attrs %{
    timestamp: ~U[2024-09-01 15:33:00Z],
    uuid: "some updated uuid",
    eth_address: "some updated eth_address",
    birdpaw_amount: 43,
    eth_amount: "456.7",
    payment_method: "some updated payment_method"
  }
  @invalid_attrs %{timestamp: nil, uuid: nil, eth_address: nil, birdpaw_amount: nil, eth_amount: nil, payment_method: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all presale_orders", %{conn: conn} do
      conn = get(conn, ~p"/api/presale_orders")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create presale_order" do
    test "renders presale_order when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/presale_orders", presale_order: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/presale_orders/#{id}")

      assert %{
               "id" => ^id,
               "birdpaw_amount" => 42,
               "eth_address" => "some eth_address",
               "eth_amount" => "120.5",
               "payment_method" => "some payment_method",
               "timestamp" => "2024-08-31T15:33:00Z",
               "uuid" => "some uuid"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/presale_orders", presale_order: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update presale_order" do
    setup [:create_presale_order]

    test "renders presale_order when data is valid", %{conn: conn, presale_order: %PresaleOrder{id: id} = presale_order} do
      conn = put(conn, ~p"/api/presale_orders/#{presale_order}", presale_order: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/presale_orders/#{id}")

      assert %{
               "id" => ^id,
               "birdpaw_amount" => 43,
               "eth_address" => "some updated eth_address",
               "eth_amount" => "456.7",
               "payment_method" => "some updated payment_method",
               "timestamp" => "2024-09-01T15:33:00Z",
               "uuid" => "some updated uuid"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, presale_order: presale_order} do
      conn = put(conn, ~p"/api/presale_orders/#{presale_order}", presale_order: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete presale_order" do
    setup [:create_presale_order]

    test "deletes chosen presale_order", %{conn: conn, presale_order: presale_order} do
      conn = delete(conn, ~p"/api/presale_orders/#{presale_order}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/presale_orders/#{presale_order}")
      end
    end
  end

  defp create_presale_order(_) do
    presale_order = presale_order_fixture()
    %{presale_order: presale_order}
  end
end
