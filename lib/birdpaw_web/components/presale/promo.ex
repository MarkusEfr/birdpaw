defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module renders the Promo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [input: 1, button: 1]
  import Birdpaw.Presale
  alias Birdpaw.PresaleUtil, as: PresaleUtil
  alias BirdpawWeb.Components.{OrderForm, OrderInfo}

  @eth_cost "0.00000016667 ETH"
  @presale_amount "150M $BIRDPAW"

  @impl true
  def handle_event(
        "confirm-buy-token",
        %{
          "birdpaw_amount" => birdpaw_amount,
          "wallet_address" => wallet_address,
          "payment_method" => payment_method,
          "amount" => amount
        } = _params,
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    # Fetch all previous orders for this address
    order_uuid = Ecto.UUID.generate()

    order = %{
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      payment_method: payment_method,
      amount: amount,
      is_confirmed?: true,
      timestamp: DateTime.utc_now(),
      uuid: order_uuid,
      order_state: "confirmed",
      qr_code_base64: presale_form[:qr_code_base64]
    }

    {:ok, created_order} = create_presale_order(order)

    IO.inspect(created_order, label: "order")

    {:noreply,
     socket
     |> put_flash(:success, "Order confirmed successfully!")
     |> assign(order: order, presale_form: Map.merge(presale_form, order))}
  end

  def handle_event(
        "select-payment_method",
        %{"payment_method" => payment_method},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    birdpaw_amount = presale_form[:birdpaw_amount] || 0
    amount = PresaleUtil.calculate_amount(birdpaw_amount, payment_method)
    updated_presale_form = %{presale_form | payment_method: payment_method, amount: amount}

    IO.inspect(updated_presale_form, label: "updated_presale_form")
    {:noreply, assign(socket, presale_form: updated_presale_form)}
  end

  @impl true
  def handle_event("toggle-buy-token", %{"toggle" => toggle}, socket) do
    {:noreply, assign(socket, :toggle_buy_token, toggle == "true")}
  end

  @impl true
  def handle_event(
        "calculate-eth",
        %{
          "birdpaw_amount" => birdpaw_amount,
          "wallet_address" => wallet_address,
          "payment_method" => payment_method
        },
        socket
      ) do
    birdpaw_amount =
      String.to_integer(birdpaw_amount)

    # Calculate amount based on selected currency
    amount =
      case payment_method do
        "ETH" ->
          PresaleUtil.calculate_amount(birdpaw_amount, "ETH")

        "USDT" ->
          PresaleUtil.calculate_amount(birdpaw_amount, "USDT")

        _ ->
          0
      end

    wei_amount = (amount * 1_000_000_000_000_000_000) |> round()

    # Generate the QR code data based on the selected payment_method, amount, and address
    qr_code_binary =
      case {wallet_address, wei_amount} do
        {"", _} -> nil
        {_, ""} -> nil
        _ -> PresaleUtil.generate_qr_code({wei_amount, amount}, wallet_address, payment_method)
      end

    presale_form = %{
      amount: amount,
      wei_amount: wei_amount,
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      qr_code_base64: qr_code_binary,
      show_link: "/payments/qr_code_#{wallet_address}.png",
      is_confirmed?: false,
      payment_method: payment_method
    }

    {:noreply, assign(socket, presale_form: presale_form)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="promo-section" class="text-white py-6 sm:py-8 md:py-10 bg-gray-900">
      <.header_section /> <.token_info_section />
      <.call_to_action myself={@myself} toggle_buy_token={@toggle_buy_token} />
      <%= if @toggle_buy_token do %>
        <.modal myself={@myself}>
          <%= if @presale_form.is_confirmed? do %>
            <.live_component id="order-info" module={OrderInfo} order={@order} />
          <% else %>
            <.live_component
              id="order-form"
              module={OrderForm}
              presale_form={@presale_form}
              myself={@myself}
            />
          <% end %>
        </.modal>
      <% end %>
    </div>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <div id="promo-header" class="text-center mb-6 sm:mb-8">
      <h1 class="text-2xl sm:text-3xl md:text-4xl font-semibold text-teal-300 tracking-tight mb-4">
        🔥 The BIRDPAW Token Presale is Open! 🔥
      </h1>

      <p class="text-sm sm:text-base md:text-lg text-gray-400 leading-relaxed max-w-xl mx-auto px-4">
        Seize the opportunity to join an exclusive community. $BIRDPAW is here to disrupt the crypto space with innovation and purpose. Get in early and secure your place in the future of decentralized finance.
      </p>
    </div>
    """
  end

  defp token_info_section(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 sm:gap-6 mb-8">
      <.info_card title="Total Presale Tokens" value={get_presale_amount()} progress={false} />
      <.info_card title="Price Per Token" value={get_cost_in_eth()} progress={false} />
      <.info_card title="Presale Progress" value="50% Sold" progress={true} />
    </div>
    """
  end

  defp info_card(assigns) do
    ~H"""
    <div class="p-4 sm:p-6 bg-gradient-to-br from-gray-800 via-gray-700 to-gray-900 rounded-xl shadow-lg text-center transition-transform duration-300 hover:scale-105 hover:shadow-2xl">
      <p class="text-base sm:text-lg font-medium text-gray-300 mb-2"><%= @title %></p>

      <%= if @progress do %>
        <div class="w-full h-2 bg-gray-600 rounded-full mt-2">
          <div class="h-2 bg-gradient-to-r from-teal-400 to-blue-500 rounded-full" style="width: 50%;">
          </div>
        </div>
      <% end %>

      <p class="text-xl sm:text-2xl font-semibold text-white mt-3"><%= @value %></p>
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
      <button class="bg-gradient-to-r from-teal-500 via-blue-500 to-teal-600 hover:bg-teal-700 text-white font-medium py-2 px-4 sm:py-3 sm:px-6 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 w-full sm:w-auto">
        💼 Reserve Your $BIRDPAW Tokens Now
      </button>
    </div>
    """
  end

  defp modal(assigns) do
    ~H"""
    <div
      id="buy-modal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-gray-900 bg-opacity-90 transition-opacity duration-300 ease-out sm:p-4"
    >
      <div class="bg-gray-900 text-white rounded-lg p-5 sm:p-6 w-full h-full max-w-sm sm:max-w-md mx-4 sm:mx-auto sm:max-h-full sm:h-auto shadow-2xl relative transform transition-all duration-300 ease-out scale-100">
        <button
          phx-click="toggle-buy-token"
          phx-value-toggle="false"
          phx-target={@myself}
          class="absolute top-3 right-3 text-gray-400 hover:text-gray-200"
        >
          ✖
        </button>
        <div class="h-full overflow-y-auto">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  defp get_presale_amount, do: @presale_amount

  defp get_cost_in_eth, do: @eth_cost
end
