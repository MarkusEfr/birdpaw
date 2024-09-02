defmodule Birdpaw.PresaleUtil do
  @moduledoc """
  This module contains utility functions for the presale.
  """

  @eth_conversion_rate 6_000_000

  @usdt_conversion_rate 0.00042

  def generate_qr_code({wei_amount, amount}, wallet_address, payment_method) do
    payment_uri =
      case payment_method do
        "ETH" ->
          "ethereum:#{wallet_address}?value=#{wei_amount}"

        "USDT" ->
          # Correctly formatted ERC20 transfer call for USDT (amount in normal units, not wei)
          "ethereum:0xdAC17F958D2ee523a2206206994597C13D831ec7/transfer?address=#{wallet_address}&token=#{amount}"

        _ ->
          raise "Unsupported payment method"
      end

    IO.inspect(payment_uri, label: "payment_uri")

    # Generate the QR code as before
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
