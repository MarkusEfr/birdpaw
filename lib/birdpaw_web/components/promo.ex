defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module renders the Promo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [simple_form: 1, input: 1, button: 1]

  @impl true
  def handle_event("toggle-buy-token", %{"toggle" => toggle}, socket) do
    {:noreply, assign(socket, :toggle_buy_token, toggle == "true")}
  end

  @impl true
  def handle_event(
        "calculate-eth",
        %{"birdpaw_amount" => birdpaw_amount, "eth_address" => eth_address},
        socket
      ) do
    birdpaw_amount = String.to_integer(birdpaw_amount)
    eth_amount = birdpaw_amount / 3_000_000

    # Generate the QR code data based on ETH amount and address
    qr_code_data = generate_qr_code(eth_amount, eth_address)

    presale_form = %{
      eth_amount: eth_amount,
      eth_address: eth_address,
      birdpaw_amount: birdpaw_amount,
      qr_code_base64: qr_code_data
    }

    {:noreply, assign(socket, presale_form: presale_form)}
  end

  defp generate_qr_code(eth_amount, eth_address) do
    payment_uri = "ethereum:#{eth_address}?value=#{eth_amount}"
    png_settings = %QRCode.Render.PngSettings{qrcode_color: {17, 170, 136}}

    # Generate the QR code (consider using a library like ElixirQRCode or similar)
    {:ok, qr_code_binary} =
      payment_uri
      |> QRCode.create()
      |> QRCode.render(:png, png_settings)
      |> QRCode.save("qr_code_#{eth_address}.png")

    QRCode.to_base64(qr_code_binary)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="promo-section" class="text-white py-16 sm:py-12 md:py-20 lg:py-24">
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
        phx-click="toggle-buy-token"
        phx-value-toggle="true"
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

            <.simple_form for={@presale_form} phx-change="calculate-eth" phx-target={@myself}>
              <.input
                field={@presale_form[:birdpaw_amount]}
                name="birdpaw_amount"
                type="number"
                label="Amount of $BIRDPAW"
                placeholder="Enter amount"
                min="100000"
                value={@presale_form[:birdpaw_amount]}
                required
              />

              <.input
                field={@presale_form[:eth_address]}
                name="eth_address"
                type="text"
                label="Your ETH Address"
                placeholder="Enter your ETH address"
                value={@presale_form[:eth_address]}
                required
              />

              <.input
                field={@presale_form[:eth_amount]}
                name="eth_amount"
                type="text"
                label="ETH to Pay"
                readonly
                value={@presale_form[:eth_amount]}
                placeholder="0 ETH"
                class="bg-gray-100"
              />
              <!-- QR Code Section -->
              <div class="mb-4 text-center">
                <%= if @presale_form[:eth_amount] > 0.0 and @presale_form[:qr_code_base64] do %>
                  <img
                    src={"data:image/svg+xml;base64,#{@presale_form[:qr_code_base64]}"}
                    alt="QR Code"
                    class="mx-auto"
                  />
                  <p class="text-sm text-gray-600 mt-2">Scan the QR code to make the payment.</p>
                <% else %>
                  <p class="text-sm text-gray-600">
                    Enter an amount and your address to generate the QR code.
                  </p>
                <% end %>
              </div>

              <:actions>
                <.button
                  type="submit"
                  class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-6 rounded-lg"
                >
                  Confirm Purchase
                </.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
