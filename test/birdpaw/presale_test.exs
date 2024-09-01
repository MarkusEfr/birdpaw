defmodule Birdpaw.PresaleTest do
  use Birdpaw.DataCase

  alias Birdpaw.Presale

  describe "presale_orders" do
    alias Birdpaw.Presale.PresaleOrder

    import Birdpaw.PresaleFixtures

    @invalid_attrs %{timestamp: nil, uuid: nil, eth_address: nil, birdpaw_amount: nil, eth_amount: nil, payment_method: nil}

    test "list_presale_orders/0 returns all presale_orders" do
      presale_order = presale_order_fixture()
      assert Presale.list_presale_orders() == [presale_order]
    end

    test "get_presale_order!/1 returns the presale_order with given id" do
      presale_order = presale_order_fixture()
      assert Presale.get_presale_order!(presale_order.id) == presale_order
    end

    test "create_presale_order/1 with valid data creates a presale_order" do
      valid_attrs = %{timestamp: ~U[2024-08-31 15:33:00Z], uuid: "some uuid", eth_address: "some eth_address", birdpaw_amount: 42, eth_amount: "120.5", payment_method: "some payment_method"}

      assert {:ok, %PresaleOrder{} = presale_order} = Presale.create_presale_order(valid_attrs)
      assert presale_order.timestamp == ~U[2024-08-31 15:33:00Z]
      assert presale_order.uuid == "some uuid"
      assert presale_order.eth_address == "some eth_address"
      assert presale_order.birdpaw_amount == 42
      assert presale_order.eth_amount == Decimal.new("120.5")
      assert presale_order.payment_method == "some payment_method"
    end

    test "create_presale_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Presale.create_presale_order(@invalid_attrs)
    end

    test "update_presale_order/2 with valid data updates the presale_order" do
      presale_order = presale_order_fixture()
      update_attrs = %{timestamp: ~U[2024-09-01 15:33:00Z], uuid: "some updated uuid", eth_address: "some updated eth_address", birdpaw_amount: 43, eth_amount: "456.7", payment_method: "some updated payment_method"}

      assert {:ok, %PresaleOrder{} = presale_order} = Presale.update_presale_order(presale_order, update_attrs)
      assert presale_order.timestamp == ~U[2024-09-01 15:33:00Z]
      assert presale_order.uuid == "some updated uuid"
      assert presale_order.eth_address == "some updated eth_address"
      assert presale_order.birdpaw_amount == 43
      assert presale_order.eth_amount == Decimal.new("456.7")
      assert presale_order.payment_method == "some updated payment_method"
    end

    test "update_presale_order/2 with invalid data returns error changeset" do
      presale_order = presale_order_fixture()
      assert {:error, %Ecto.Changeset{}} = Presale.update_presale_order(presale_order, @invalid_attrs)
      assert presale_order == Presale.get_presale_order!(presale_order.id)
    end

    test "delete_presale_order/1 deletes the presale_order" do
      presale_order = presale_order_fixture()
      assert {:ok, %PresaleOrder{}} = Presale.delete_presale_order(presale_order)
      assert_raise Ecto.NoResultsError, fn -> Presale.get_presale_order!(presale_order.id) end
    end

    test "change_presale_order/1 returns a presale_order changeset" do
      presale_order = presale_order_fixture()
      assert %Ecto.Changeset{} = Presale.change_presale_order(presale_order)
    end
  end
end
