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
  def handle_event(
        "confirm-buy-token",
        %{
          "birdpaw_amount" => birdpaw_amount,
          "eth_address" => eth_address,
          "eth_amount" => eth_amount
        } = _params,
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    order_uuid = Ecto.UUID.generate() |> Base.encode16(case: :lower)

    order = %{
      eth_address: eth_address,
      birdpaw_amount: birdpaw_amount,
      eth_amount: eth_amount,
      is_confirmed?: true,
      timestamp: Timex.now() |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime),
      uuid: order_uuid
    }

    {:noreply, socket |> assign(order: order, presale_form: Map.merge(presale_form, order))}
  end

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
    wei_amount = (eth_amount * 1_000_000_000_000_000_000) |> round()

    # Generate the QR code data based on ETH amount and address
    qr_code_binary =
      case {eth_address, eth_amount} do
        {"", _} -> nil
        {_, ""} -> nil
        _ -> generate_qr_code(wei_amount, eth_address)
      end

    presale_form = %{
      eth_amount: eth_amount,
      wei_amount: wei_amount,
      eth_address: eth_address,
      birdpaw_amount: birdpaw_amount,
      qr_code_base64: qr_code_binary,
      show_link: "/payments/qr_code_#{eth_address}.png",
      is_confirmed?: false
    }

    {:noreply, assign(socket, presale_form: presale_form)}
  end

  defp generate_qr_code(wei_amount, eth_address) do
    payment_uri = "ethereum:#{eth_address}?value=#{wei_amount}"
    png_settings = %QRCode.Render.PngSettings{qrcode_color: {17, 170, 136}}

    # Generate the QR code
    {:ok, qr_code_binary} =
      payment_uri
      |> QRCode.create()
      |> QRCode.render(:png, png_settings)
      |> QRCode.save("priv/payments/qr_code_#{eth_address}.png")

    qr_code_binary
  end

  def render(assigns) do
    ~H"""
    <div id="promo-section" class="text-white py-8 sm:py-12 md:py-20 bg-gray-900">
      <.header_section />
      <.token_info_section />
      <.call_to_action myself={@myself} toggle_buy_token={@toggle_buy_token} />
      <%= if @toggle_buy_token do %>
        <.modal myself={@myself}>
          <%= if @presale_form.is_confirmed? do %>
            <.order_info order={@order} />
          <% else %>
            <.order_form presale_form={@presale_form} myself={@myself} />
          <% end %>
        </.modal>
      <% end %>
    </div>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <div id="promo-header" class="text-center mb-8 sm:mb-12">
      <h1 class="text-3xl sm:text-4xl md:text-5xl font-extrabold text-teal-400 mb-4">
        🎉 Welcome to the $BIRDPAW Presale! 🎉
      </h1>
      <p class="text-base sm:text-lg md:text-xl font-light text-gray-300">
        Join the adventure and hunt for treasures in the crypto jungle!
      </p>
    </div>
    """
  end

  defp token_info_section(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 sm:gap-6 md:gap-8 mb-8 sm:mb-12">
      <.info_card title="Total Presale Tokens" value="150M $BIRDPAW" progress={false} />
      <.info_card title="Price Per Token" value="0.00000033 ETH" progress={false} />
      <.info_card title="Progress" value="50% Sold" progress={true} />
    </div>
    """
  end

  defp info_card(assigns) do
    ~H"""
    <div class="p-6 sm:p-8 bg-gradient-to-tr from-teal-500 to-blue-500 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-105 hover:shadow-xl">
      <p class="text-lg sm:text-xl font-semibold text-white"><%= @title %></p>
      <%= if @progress do %>
        <div class="w-full h-3 sm:h-4 bg-gray-700 rounded-full mt-3 sm:mt-4">
          <div class="h-3 sm:h-4 bg-teal-400 rounded-full" style="width: 50%;"></div>
        </div>
      <% end %>
      <p class="text-2xl sm:text-3xl font-bold text-white mt-2"><%= @value %></p>
    </div>
    """
  end

  defp call_to_action(assigns) do
    ~H"""
    <div
      id="payment-container"
      phx-click="toggle-buy-token"
      phx-value-toggle="true"
      phx-target={@myself}
      class="text-center mt-6 sm:mt-8"
    >
      <button class="bg-yellow-500 hover:bg-yellow-600 text-gray-900 font-bold py-3 px-6 sm:py-3 sm:px-8 rounded-lg transition duration-300 hover:shadow-xl w-full sm:w-auto">
        🐾 Grab Your $BIRDPAW Now!
      </button>
    </div>
    """
  end

  defp modal(assigns) do
    ~H"""
    <div
      id="buy-modal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-gray-800 bg-opacity-75 transition-opacity duration-300 ease-out"
    >
      <div class="bg-gray-900 text-white rounded-lg p-6 sm:p-8 w-full max-w-sm sm:max-w-md mx-4 sm:mx-auto shadow-lg relative transform transition-all duration-300 ease-out scale-95">
        <button
          phx-click="toggle-buy-token"
          phx-value-toggle="false"
          phx-target={@myself}
          class="absolute top-3 sm:top-4 right-3 sm:right-4 text-gray-500 hover:text-gray-300"
        >
          ✖
        </button>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp order_form(assigns) do
    ~H"""
    <.simple_form
      for={@presale_form}
      phx-change="calculate-eth"
      phx-target={@myself}
      phx-submit="confirm-buy-token"
      class="space-y-4"
    >
      <.input
        field={@presale_form[:birdpaw_amount]}
        name="birdpaw_amount"
        type="number"
        label="Amount of $BIRDPAW"
        placeholder="Enter amount"
        min="100000"
        step="1000"
        class="bg-gray-800 text-white border border-gray-600 placeholder-gray-500 focus:border-teal-400 focus:ring-teal-400 rounded-lg shadow-sm p-2 w-full"
        value={@presale_form[:birdpaw_amount]}
        required
      />

      <.input
        field={@presale_form[:eth_address]}
        name="eth_address"
        type="text"
        label="Your ETH Address"
        placeholder="Enter your ETH address"
        class="bg-gray-800 text-white border border-gray-600 placeholder-gray-500 focus:border-teal-400 focus:ring-teal-400 rounded-lg shadow-sm p-2 w-full"
        value={@presale_form[:eth_address]}
        required
      />

      <.input
        field={@presale_form[:eth_amount]}
        name="eth_amount"
        type="text"
        label="ETH to Pay"
        readonly
        class="bg-gray-900 text-white border border-gray-600 placeholder-gray-500 focus:border-teal-400 focus:ring-teal-400 rounded-lg shadow-sm p-2 w-full"
        value={@presale_form[:eth_amount]}
        placeholder="0 ETH"
      />

      <:actions>
        <.button
          type="submit"
          phx-disable-with="Confirming..."
          hidden={@presale_form[:is_confirmed?]}
          disabled={
            @presale_form[:eth_amount] == 0.0 or
              @presale_form[:eth_address] |> String.trim() == ""
          }
          class="bg-teal-400 hover:bg-teal-500 text-gray-900 font-bold py-2 px-6 rounded-lg disabled:opacity-50 transition duration-300 ease-in-out transform hover:scale-105 disabled:cursor-not-allowed w-full"
        >
          Confirm Purchase
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  defp order_info(assigns) do
    ~H"""
    <div class="text-center bg-gray-900 rounded-lg p-6 sm:p-8 shadow-lg">
      <p class="text-xl sm:text-2xl font-bold text-teal-400 mb-6">Order Confirmed!</p>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">Order ID</p>
        <p class="text-sm sm:text-base font-semibold text-white truncate"><%= @order.uuid %></p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">
          ETH Address
        </p>
        <p class="text-sm sm:text-base font-semibold text-white truncate">
          <%= @order.eth_address %>
        </p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">
          Amount of $BIRDPAW
        </p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.birdpaw_amount %></p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">
          Amount of ETH
        </p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.eth_amount %></p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-6">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">Timestamp</p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.timestamp <> " UTC" %></p>
      </div>

      <img
        src={~p"/payments/qr_code_0xDc484b655b157387B493DFBeDbeC4d44A248566F.png"}
        alt="QR code"
        class="mx-auto mt-6 rounded-lg shadow-lg"
      />
      <p class="text-xs sm:text-sm text-gray-400 mt-4">Scan the QR code to make the payment.</p>
    </div>
    """
  end
end
