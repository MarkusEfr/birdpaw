defmodule BirdpawWeb.PresaleOrderJSON do
  alias Birdpaw.Presale.PresaleOrder

  @doc """
  Renders a list of presale_orders.
  """
  def index(%{presale_orders: presale_orders}) do
    %{data: for(presale_order <- presale_orders, do: data(presale_order))}
  end

  @doc """
  Renders a single presale_order.
  """
  def show(%{presale_order: presale_order}) do
    %{data: data(presale_order)}
  end

  defp data(%PresaleOrder{} = presale_order) do
    %{
      id: presale_order.id,
      uuid: presale_order.uuid,
      wallet_address: presale_order.wallet_address,
      birdpaw_amount: presale_order.birdpaw_amount,
      amount: presale_order.amount,
      timestamp: presale_order.timestamp,
      payment_method: presale_order.payment_method
    }
  end
end
