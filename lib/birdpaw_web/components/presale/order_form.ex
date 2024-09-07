defmodule BirdpawWeb.Components.OrderForm do
  @moduledoc """
  This module renders the OrderForm component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [input: 1, button: 1]

  def render(assigns) do
    ~H"""
    <div
      id="order-form-section"
      class="bg-gray-900 text-center rounded-lg p-6 sm:p-8 shadow-xl max-w-md sm:max-w-lg lg:max-w-2xl mx-auto"
    >
      <!-- Form Header -->
      <p class="text-2xl sm:text-3xl lg:text-4xl font-bold text-teal-400 mb-6 lg:mb-8">
        Buy $BIRDPAW
      </p>
      <!-- Form -->
      <.form
        for={@presale_form}
        phx-change="calculate-eth"
        phx-target={@myself}
        phx-submit="confirm-buy-token"
        class="space-y-4 lg:space-y-6"
      >
        <!-- Amount of $BIRDPAW -->
        <div class="flex justify-between items-center">
          <label class="text-sm sm:text-base lg:text-lg text-gray-400 font-medium">
            Amount of $BIRDPAW
          </label>
          <.input
            field={@presale_form[:birdpaw_amount]}
            value={@presale_form[:birdpaw_amount] || 50_000}
            name="birdpaw_amount"
            type="number"
            placeholder="Enter amount"
            min="50000"
            step="1000"
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full sm:w-2/3 lg:w-1/2"
            required
          />
        </div>
        <!-- Wallet Address -->
        <div class="flex justify-between items-center">
          <label class="text-sm sm:text-base lg:text-lg text-gray-400 font-medium">
            Your Wallet Address
          </label>
          <.input
            field={@presale_form[:wallet_address]}
            value={@presale_form[:wallet_address] || ""}
            name="wallet_address"
            type="text"
            placeholder="Enter your wallet address"
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full sm:w-2/3 lg:w-1/2"
          />
        </div>
        <!-- Notice Section -->
        <div class="flex items-start bg-gray-700 text-white p-3 rounded-lg space-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-teal-300 flex-shrink-0"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M18 10A8 8 0 1110 2a8 8 0 018 8zm-7-2a1 1 0 10-2 0v3a1 1 0 001 1h1a1 1 0 100-2h-1V8zM9 14a1 1 0 112 0 1 1 0 01-2 0z"
              clip-rule="evenodd"
            />
          </svg>
          <p class="text-xs sm:text-sm text-left">
            If you do not provide an ERC20 wallet address, we will use the payment address for receiving $BIRDPAW tokens.
          </p>
        </div>
        <!-- Payment Method Selection -->
        <div class="flex justify-between items-center space-x-4 py-2">
          <label class="text-sm sm:text-base lg:text-lg text-gray-400 font-medium">
            Payment Method
          </label>
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
        </div>
        <!-- Hidden Input to Store Payment Method -->
        <input type="hidden" name="payment_method" value={@presale_form[:payment_method] || "ETH"} />
        <!-- Amount -->
        <div class="flex justify-between items-center">
          <label class="text-sm sm:text-base lg:text-lg text-teal-300 font-medium">
            Amount to Pay
          </label>
          <.input
            field={@presale_form[:amount]}
            value={@presale_form[:amount] || 0.0}
            name="amount"
            type="text"
            readonly
            class="bg-gray-700 text-white border border-teal-500 placeholder-gray-400 focus:border-teal-500 focus:ring-teal-500 rounded-lg p-3 w-full sm:w-2/3 lg:w-1/2"
          />
        </div>
        <!-- Submit Button -->
        <div class="flex justify-center pt-4">
          <.button
            type="submit"
            phx-disable-with="Processing..."
            hidden={@presale_form[:is_confirmed?]}
            disabled={@presale_form[:amount] == 0.0}
            class="w-full sm:w-2/3 lg:w-1/2 bg-teal-500 hover:bg-teal-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Confirm Purchase
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
