defmodule Birdpaw.PresaleUtil do
  @moduledoc """
  This module contains utility functions for the presale.
  """

  import Birdpaw.Presale

  @eth_conversion_rate 6_000_000
  @usdt_conversion_rate 0.00042
  @usdt_decimal_factor :math.pow(10, 6) |> round()
  @owner_wallet "0xDc484b655b157387B493DFBeDbeC4d44A248566F"

  @page_size 10

  def get_page_size, do: @page_size

  def get_page_orders(orders, page) when page == 1, do: Enum.slice(orders, 0, @page_size)
  def get_page_orders(orders, page), do: Enum.slice(orders, @page_size * (page - 1), @page_size)

  def generate_qr_code({wei_amount, amount}, _wallet_address, payment_method) do
    payment_uri =
      case payment_method do
        "ETH" ->
          "ethereum:#{@owner_wallet}?value=#{wei_amount}"

        "USDT" ->
          usdt_amount_in_smallest_units = round(amount * @usdt_decimal_factor)

          "ethereum:0xdAC17F958D2ee523a2206206994597C13D831ec7/transfer?address=#{@owner_wallet}&uint256=#{usdt_amount_in_smallest_units}"

        _ ->
          raise "Unsupported payment method"
      end

    png_settings = %QRCode.Render.PngSettings{qrcode_color: {17, 170, 136}, scale: 5}

    {:ok, qr_code_binary} =
      payment_uri
      |> QRCode.create(:high)
      |> QRCode.render(:png, png_settings)
      |> QRCode.to_base64()

    qr_code_binary
  end

  def get_usdt_conversion_rate, do: @usdt_conversion_rate

  def get_eth_conversion_rate, do: @eth_conversion_rate

  def calculate_amount(birdpaw_amount, "ETH") do
    birdpaw_amount / @eth_conversion_rate
  end

  def calculate_amount(birdpaw_amount, "USDT") do
    birdpaw_amount * @usdt_conversion_rate
  end

  def calculate_amount(_birdpaw_amount, _payment_method) do
    0
  end

  def fetch_orders(%{"search_query" => ""} = search_params), do: fetch_orders(search_params)

  def fetch_orders(search_query) do
    search_params = build_search_params(search_query)

    orders =
      search_params
      |> get_orders_by_params()
      |> Enum.map(fn order ->
        %{
          id: order.id,
          uuid: order.uuid,
          wallet_address: order.wallet_address,
          birdpaw_amount: order.birdpaw_amount,
          amount: order.amount,
          timestamp: order.timestamp,
          payment_method: order.payment_method,
          order_state: order.order_state
        }
      end)
      |> Enum.sort_by(fn order -> order.timestamp end, &>/2)

    total_orders = Enum.count(orders)

    if total_orders > 0 do
      %{
        orders: orders,
        selected: get_page_orders(orders, 1),
        page: 1,
        total_pages:
          if(total_orders > @page_size, do: total_orders / @page_size, else: 1) |> ceil(),
        search_query: ""
      }
    else
      %{
        orders: [],
        selected: [],
        page: 1,
        total_pages: 1,
        search_query: ""
      }
    end
  end

  # Helper function to build search parameters based on search query
  def build_search_params(search_query) do
    cond do
      is_uuid(search_query) ->
        %{uuid: search_query}

      is_erc20_wallet(search_query) ->
        %{wallet_address: search_query}

      true ->
        # Return an empty map if no valid query
        %{}
    end
  end

  def is_uuid(search_query) do
    Regex.match?(
      ~r/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/,
      search_query
    )
  end

  # Helper function to detect if the input is an ERC20 wallet address
  def is_erc20_wallet(search_query) do
    Regex.match?(~r/^0x[a-fA-F0-9]{40}$/, search_query)
  end

  def update_order_state(order, new_state) do
    %{order | order_state: new_state}

    case update_presale_order(order, %{order_state: new_state}) do
      {:ok, %Birdpaw.PresaleOrder{} = updated_order} ->
        updated_order

      _ ->
        {:error, "Failed to update order state"}
    end
  end

  def define_index_based_on_page(data), do: data.page * get_page_size() - get_page_size()
end
