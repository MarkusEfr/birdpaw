defmodule Birdpaw.PresaleUtil do
  @moduledoc """
  This module contains utility functions for the presale.
  """

  @eth_conversion_rate 6_000_000
  @usdt_conversion_rate 0.00042
  @usdt_decimal_factor :math.pow(10, 6) |> round()
  @owner_wallet "0xDc484b655b157387B493DFBeDbeC4d44A248566F"

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

    IO.inspect(payment_uri, label: "payment_uri")

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
end
