defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module is used to render the Promo component for the Birdpaw token presale.
  """
  use BirdpawWeb, :live_component

  @impl true
  def handle_event("toggle-buy-token", %{"toggle" => toggle} = params, socket) do
    {:noreply, assign(socket, :toggle_buy_token, toggle == "true")}
  end

  @impl true
  def handle_event("calculate-eth", %{"birdpaw_amount" => birdpaw_amount}, socket) do
    birdpaw_amount = String.to_integer(birdpaw_amount)
    eth_amount = birdpaw_amount / 3_000_000
    {:noreply, assign(socket, eth_amount: eth_amount)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="promo-section"
      class="text-white py-16 sm:py-12 md:py-20 lg:py-24"
    >
      <!-- Header Section -->
      <div id="promo-header" class="text-center mb-12">
        <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold mb-4 typing-effect">
          🎉 Welcome to the $BIRDPAW Presale! 🎉
        </h1>

        <p class="text-lg sm:text-xl md:text-2xl font-light fade-in-scale">
          Join the adventure and hunt for treasures in the crypto jungle!
        </p>
      </div>
      <!-- Token Information Section -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 mb-12">
        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Total Presale Tokens</p>

          <p class="text-3xl font-bold">150M $BIRDPAW</p>
        </div>

        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Price Per Token</p>

          <p class="text-3xl font-bold">0.00000033 ETH</p>
        </div>

        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Progress</p>

          <div class="w-full h-4 bg-gray-300 rounded-full mt-4">
            <div class="h-4 bg-green-500 rounded-full" style="width: 50%;"></div>
          </div>

          <p class="text-sm mt-2 text-gray-200">50% Sold</p>
        </div>
      </div>
      <!-- Call to Action -->
      <div
        id="payment-container"
        phx-value-toggle="true"
        phx-click="toggle-buy-token"
        phx-target={@myself}
        class="text-center mt-8"
      >
        <button class="bg-yellow-500 hover:bg-yellow-600 text-gray-900 font-bold py-3 px-8 rounded-lg transition duration-300 hover:shadow-xl">
          🐾 Grab Your $BIRDPAW Now!
        </button>
      </div>
      <!-- Full-Screen Modal -->
      <%= if @toggle_buy_token do %>
        <div
          id="buy-modal"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-75 transition-opacity duration-300 ease-out"
        >
          <div class="bg-white rounded-lg p-8 w-full max-w-md mx-auto text-gray-800 relative transform transition-all duration-300 ease-out scale-95">
            <button
              phx-click="toggle-buy-token"
              phx-value-toggle="false"
              phx-target={@myself}
              class="absolute top-4 right-4 text-gray-500 hover:text-gray-700"
            >
              ✖
            </button>

            <h2 class="text-2xl font-bold mb-4 text-center">Buy $BIRDPAW</h2>

            <form phx-change="calculate-eth" phx-target={@myself}>
              <div class="mb-4">
                <label class="block text-gray-700">Amount of $BIRDPAW</label>
                <input
                  type="number"
                  name="birdpaw_amount"
                  class="w-full p-2 border rounded"
                  placeholder="Enter amount"
                  min="100000"
                  required
                />
              </div>

              <div class="mb-4">
                <label class="block text-gray-700">Your ETH Address</label>
                <input
                  type="text"
                  name="eth_address"
                  class="w-full p-2 border rounded"
                  placeholder="Enter your ETH address"
                  required
                />
              </div>

              <div class="mb-4">
                <label class="block text-gray-700">ETH to Pay</label>
                <input
                  type="text"
                  name="eth_amount"
                  value={@eth_amount}
                  readonly
                  class="w-full p-2 border rounded bg-gray-100"
                  placeholder="0 ETH"
                />
              </div>
              <!-- QR Code Section -->
              <div class="mb-4 text-center">
                <%= if @eth_amount > 0.0 and @qr_code_base64 do %>
                  <img
                    src={"data:image/svg+xml;base64,#{@qr_code_base64}"}
                    alt="QR Code"
                    class="mx-auto"
                  />
                  <p class="text-sm text-gray-600 mt-2">Scan the QR code to make the payment.</p>
                <% else %>
                  <p class="text-sm text-gray-600">Enter an amount to generate the QR code.</p>
                <% end %>
              </div>

              <div class="text-center">
                <button
                  type="submit"
                  class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-6 rounded-lg"
                >
                  Confirm Purchase
                </button>
              </div>
            </form>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
