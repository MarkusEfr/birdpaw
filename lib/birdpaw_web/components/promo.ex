defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module renders the Promo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [simple_form: 1, input: 1, button: 1]
  import Birdpaw.Presale

  @currencies ["ETH", "USDT", "BTC"]

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
    previous_orders = get_orders_by_wallet_address(wallet_address)
    IO.inspect(previous_orders)

    # Check if the user has made more than 10 orders
    if length(previous_orders) >= 10 do
      # Return an error if the user has more than 10 orders
      {:noreply,
       socket
       |> put_flash(:error, "You have reached the maximum number of orders.")
       |> assign(presale_form: presale_form)}
    else
      # Check if the new order's payment_method and amount match any previous order
      matching_order =
        Enum.find(previous_orders, fn order ->
          order.payment_method == payment_method && order.amount == amount
        end)

      if matching_order do
        # Return an error if a matching order is found
        {:noreply,
         socket
         |> put_flash(
           :error,
           "You have already placed an order with the same payment method and amount."
         )
         |> assign(presale_form: presale_form)}
      else
        # If validations pass, proceed with order creation
        order_uuid = Ecto.UUID.generate() |> Base.encode16(case: :lower)

        order = %{
          wallet_address: wallet_address,
          birdpaw_amount: birdpaw_amount,
          payment_method: payment_method,
          amount: amount,
          is_confirmed?: true,
          timestamp: DateTime.utc_now(),
          uuid: order_uuid,
          order_state: "confirmed"
        }

        # Insert the new order into the database
        {:ok, created_order} = create_presale_order(order)

        IO.inspect(created_order, label: "order")

        {:noreply,
         socket
         |> put_flash(:success, "Order confirmed successfully!")
         |> assign(order: order, presale_form: Map.merge(presale_form, order))}
      end
    end
  end

  def handle_event(
        "select-payment_method",
        %{"payment_method" => payment_method},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply, assign(socket, presale_form: %{presale_form | payment_method: payment_method})}
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
    birdpaw_amount = String.to_integer(birdpaw_amount)

    # Set conversion rates (example: 1 USDT = 0.00033 ETH, adjust these as needed)
    eth_conversion_rate = 3_000_000
    usdt_conversion_rate = 0.00033

    # Calculate amount based on selected currency
    amount =
      case payment_method do
        "ETH" ->
          birdpaw_amount / eth_conversion_rate

        "USDT" ->
          birdpaw_amount * usdt_conversion_rate

        _ ->
          0
      end

    wei_amount = (amount * 1_000_000_000_000_000_000) |> round()

    # Generate the QR code data based on the selected payment_method, amount, and address
    qr_code_binary =
      case {wallet_address, wei_amount} do
        {"", _} -> nil
        {_, ""} -> nil
        _ -> generate_qr_code(wei_amount, wallet_address)
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
          value={@presale_form[:birdpaw_amount] || 100_000}
          name="birdpaw_amount"
          type="number"
          placeholder="Enter amount"
          min="100000"
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
          disabled={@presale_form[:amount] == 0.0 or @presale_form[:wallet_address] in [nil, ""]}
          class="w-full bg-teal-500 hover:bg-teal-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Confirm Purchase
        </.button>
      </div>
    </.form>
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
          Order State
        </p>
        <p class="text-sm sm:text-base font-semibold text-white truncate">
          <%= @order.order_state %>
        </p>
      </div>
      <!-- Additional fields... -->
      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">
          Amount of $BIRDPAW
        </p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.birdpaw_amount %></p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">
          Amount of <%= @order.payment_method %>
        </p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.amount %></p>
      </div>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-6">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">Timestamp</p>
        <p class="text-sm sm:text-base font-semibold text-white"><%= @order.timestamp %></p>
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

  defp get_currency_options, do: @currencies
end
