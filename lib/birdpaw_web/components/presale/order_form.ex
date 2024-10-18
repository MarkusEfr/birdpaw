defmodule BirdpawWeb.Components.OrderForm do
  @moduledoc """
  Compact and card-style variant for the Birdpaw token presale form.
  The form changes dynamically based on the selected payment variant.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [input: 1, button: 1]

  def render(assigns) do
    ~H"""
    <div
      id="order-form-section"
      class="bg-gray-800 rounded-lg shadow-md p-6 sm:p-8 max-w-md lg:max-w-xl mx-auto"
    >
      <!-- Card Header -->
      <div class="border-b border-teal-500 pb-4 mb-6">
        <h2 class="text-xl font-bold text-teal-400">Buy $BIRDPAW Tokens</h2>
      </div>
      <!-- Payment Option Cards -->
      <div class="grid grid-cols-2 gap-4 mb-6">
        <div
          phx-click="select-payment-method"
          phx-value-method="wallet"
          class={"cursor-pointer border-2 rounded-lg p-4 text-center text-gray-300 #{if @presale_form[:payment_variant] == "wallet", do: "border-teal-500", else: "border-gray-600"}"}
        >
          <span class="block text-lg font-semibold">Web3 Wallet</span>
          <small class="block text-xs">Connect with MetaMask</small>
        </div>
        <div
          phx-click="select-payment-method"
          phx-value-method="qr"
          class={"cursor-pointer border-2 rounded-lg p-4 text-center text-gray-300 #{if @presale_form[:payment_variant] == "qr", do: "border-teal-500", else: "border-gray-600"}"}
        >
          <span class="block text-lg font-semibold">QR Payment</span>
          <small class="block text-xs">Generate QR Code</small>
        </div>
      </div>
      <!-- Form for Token Purchase -->
      <.form
        for={@presale_form}
        phx-change="calculate-amount"
        phx-submit="confirm-buy-token"
        class="space-y-4"
      >
        <!-- Amount of $BIRDPAW -->
        <div class="border border-gray-700 rounded-lg p-4 mb-4">
          <h3 class="text-gray-400 text-sm mb-2">Amount of $BIRDPAW</h3>
          <.input
            field={@presale_form[:birdpaw_amount]}
            value={@presale_form[:birdpaw_amount] || 50_000}
            name="birdpaw_amount"
            type="number"
            placeholder="50,000"
            min="50000"
            step="1000"
            class="bg-gray-700 text-white border-none rounded-md w-full"
            required
          />
        </div>

        <div class="border border-gray-700 rounded-lg p-4 mb-4">
          <h3 class="text-gray-400 text-sm mb-2">Your Wallet Address</h3>
          <.input
            field={@presale_form[:wallet_address]}
            value={@presale_form[:wallet_address] || ""}
            name="wallet_address"
            type="text"
            placeholder="0x..."
            class="bg-gray-700 text-white border-none rounded-md w-full"
          />
        </div>
        <!-- Payment Method Selection (Visible for QR Payment) -->
        <%= if @presale_form[:payment_variant] == "qr" do %>
          <div class="border border-gray-700 rounded-lg p-4 mb-4">
            <h3 class="text-gray-400 text-sm mb-2">Payment Method</h3>
            <div class="flex justify-center space-x-4">
              <div
                id="payment_method-eth"
                phx-click="select-payment-method-type"
                phx-value-payment_method="ETH"
                class={"cursor-pointer p-2 #{if @presale_form[:payment_method] == "ETH", do: "bg-teal-700", else: "bg-gray-600"} text-white rounded-lg shadow-md"}
              >
                ETH
              </div>
              <div
                id="payment_method-usdt"
                phx-click="select-payment-method-type"
                phx-value-payment_method="USDT"
                class={"cursor-pointer p-2 #{if @presale_form[:payment_method] == "USDT", do: "bg-teal-700", else: "bg-gray-600"} text-white rounded-lg shadow-md"}
              >
                USDT
              </div>
            </div>
          </div>
        <% end %>
        <input type="hidden" name="payment_method" value={@presale_form[:payment_method] || "ETH"} />
        <!-- Amount Display -->
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
        <!-- Confirm Button -->
        <div class="mt-6">
          <.button
            type="submit"
            phx-disable-with="Processing..."
            hidden={@presale_form[:is_confirmed?]}
            disabled={checkout_disabled?(@presale_form)}
            class="w-full bg-teal-500 hover:bg-teal-600 text-white font-bold py-3 rounded-lg transition duration-300"
          >
            Confirm Purchase
          </.button>
        </div>
      </.form>
      <!-- QR Code Section (Visible After Confirmation) -->
      <%= if @presale_form[:is_confirmed?] and @presale_form[:payment_variant] == "qr" do %>
        <div class="bg-gray-700 text-white p-4 rounded-lg mt-6">
          <h3 class="text-gray-400 text-sm mb-4">Complete Payment Using QR Code</h3>
          <p class="text-sm mb-4">Scan the QR code below to finish the payment.</p>
          <img src={@presale_form[:qr_code_base64]} alt="QR Code" class="mx-auto mb-4 w-32 h-32" />
          <div class="text-center">
            <button
              phx-click="generate-qr-code"
              class="bg-teal-500 hover:bg-teal-600 text-white font-semibold py-2 px-4 rounded-lg"
            >
              Generate New QR Code
            </button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp checkout_disabled?(presale_form) do
    presale_form[:birdpaw_amount] < 50_000 or
      (presale_form[:payment_method] == "ETH" and presale_form[:amount] < 0.0080) or
      (presale_form[:payment_method] == "USDT" and presale_form[:amount] < 21)
  end
end
