defmodule BirdpawWeb.Components.OrderForm do
  @moduledoc """
  This module renders the OrderForm component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [input: 1, button: 1]
  import Birdpaw.Presale

  @eth_conversion_rate 6_000_000

  def render(assigns) do
    ~H"""
    <div id="order-form-section">
      <.form
        for={@presale_form}
        phx-change="calculate-eth"
        phx-target={@myself}
        phx-submit="confirm-buy-token"
        class="space-y-6 bg-gray-800 p-6 rounded-lg shadow-xl"
      >
        <!-- Form Header -->
        <div class="text-center">
          <h2 class="text-2xl font-bold text-white mb-4">Buy $BIRDPAW</h2>
        </div>
        <!-- Amount of $BIRDPAW -->
        <div class="space-y-2">
          <label class="text-white">Amount of $BIRDPAW</label>
          <.input
            field={@presale_form[:birdpaw_amount]}
            value={@presale_form[:birdpaw_amount] || 50_000}
            name="birdpaw_amount"
            type="number"
            placeholder="Enter amount"
            min="50000"
            step="1000"
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full"
            required
          />
        </div>
        <!-- Wallet Address -->
        <div class="space-y-2">
          <label class="text-white">Your Wallet Address</label>
          <.input
            field={@presale_form[:wallet_address]}
            value={@presale_form[:wallet_address] || ""}
            name="wallet_address"
            type="text"
            placeholder="Enter your wallet address"
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full"
            required
          />
        </div>
        <!-- Payment Method Selection -->
        <div class="space-y-2">
          <label class="text-white">Payment Method</label>
          <div class="flex justify-center space-x-4 py-2">
            <div
              id="payment_method-eth"
              phx-click="select-payment_method"
              phx-value-payment_method="ETH"
              phx-target={@myself}
              class={"cursor-pointer p-2 #{if @presale_form[:payment_method] == "ETH", do: "bg-teal-700", else: "bg-gray-600"} text-white rounded-lg shadow-md"}
            >
              ETH
            </div>

            <div
              id="payment_method-usdt"
              phx-click="select-payment_method"
              phx-value-payment_method="USDT"
              phx-target={@myself}
              class={"cursor-pointer p-2 #{if @presale_form[:payment_method] == "USDT", do: "bg-teal-700", else: "bg-gray-600"} text-white rounded-lg shadow-md"}
            >
              USDT
            </div>
          </div>

          <input
            type="hidden"
            name="payment_method"
            id="payment_method-input"
            value={@presale_form[:payment_method] || "ETH"}
          />
        </div>
        <!-- Amount -->
        <div class="space-y-2">
          <label class="text-teal-300">Amount to Pay</label>
          <.input
            field={@presale_form[:amount]}
            value={@presale_form[:amount] || 0.0}
            name="amount"
            type="text"
            readonly
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full"
          />
        </div>
        <!-- Submit Button -->
        <div class="pt-4">
          <.button
            type="submit"
            phx-disable-with="Processing..."
            hidden={@presale_form[:is_confirmed?]}
            disabled={
              @presale_form[:amount] == 0.0 or
                (@presale_form[:wallet_address] |> String.trim()) in [nil, ""]
            }
            class="w-full bg-teal-500 hover:bg-teal-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Confirm Purchase
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
