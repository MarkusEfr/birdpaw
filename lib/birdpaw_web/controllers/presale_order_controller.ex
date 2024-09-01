defmodule BirdpawWeb.PresaleOrderController do
  use BirdpawWeb, :controller

  alias Birdpaw.Presale
  alias Birdpaw.Presale.PresaleOrder

  action_fallback BirdpawWeb.FallbackController

  def index(conn, _params) do
    presale_orders = Presale.list_presale_orders()
    render(conn, :index, presale_orders: presale_orders)
  end

  def create(conn, %{"presale_order" => presale_order_params}) do
    with {:ok, %PresaleOrder{} = presale_order} <- Presale.create_presale_order(presale_order_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/presale_orders/#{presale_order}")
      |> render(:show, presale_order: presale_order)
    end
  end

  def show(conn, %{"id" => id}) do
    presale_order = Presale.get_presale_order!(id)
    render(conn, :show, presale_order: presale_order)
  end

  def update(conn, %{"id" => id, "presale_order" => presale_order_params}) do
    presale_order = Presale.get_presale_order!(id)

    with {:ok, %PresaleOrder{} = presale_order} <- Presale.update_presale_order(presale_order, presale_order_params) do
      render(conn, :show, presale_order: presale_order)
    end
  end

  def delete(conn, %{"id" => id}) do
    presale_order = Presale.get_presale_order!(id)

    with {:ok, %PresaleOrder{}} <- Presale.delete_presale_order(presale_order) do
      send_resp(conn, :no_content, "")
    end
  end
end
