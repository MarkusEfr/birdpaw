defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module renders the Promo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component
  import BirdpawWeb.CoreComponents, only: [button: 1]
  import Birdpaw.Presale
  import Birdpaw.PresaleUtil
  alias BirdpawWeb.Components.{OrderForm, OrderInfo, ImageModal, SearchModal}

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
    order_uuid = Ecto.UUID.generate()

    order = %{
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      payment_method: payment_method,
      amount: amount,
      is_confirmed?: true,
      timestamp: DateTime.utc_now(),
      uuid: order_uuid,
      order_state: "pending",
      qr_code_base64: presale_form[:qr_code_base64]
    }

    {:ok, _created_order} = create_presale_order(order)

    {:noreply,
     socket
     |> put_flash(:success, "Order created successfully!")
     |> assign(order: order, presale_form: Map.merge(presale_form, order))}
  end

  def handle_event(
        "select-payment_method",
        %{"payment_method" => payment_method},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    birdpaw_amount = presale_form[:birdpaw_amount] || 0
    amount = calculate_amount(birdpaw_amount, payment_method)
    updated_presale_form = %{presale_form | payment_method: payment_method, amount: amount}

    {:noreply, assign(socket, presale_form: updated_presale_form)}
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
          calculate_amount(birdpaw_amount, "ETH")

        "USDT" ->
          calculate_amount(birdpaw_amount, "USDT")

        _ ->
          0
      end

    wei_amount = (amount * 1_000_000_000_000_000_000) |> round()

    # Generate the QR code data based on the selected payment_method, amount, and address
    qr_code_binary =
      case {wallet_address, wei_amount} do
        {_, ""} -> nil
        _ -> generate_qr_code({wei_amount, amount}, wallet_address, payment_method)
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
  def handle_event("toggle-buy-token", %{"toggle" => toggle}, socket) do
    {:noreply, assign(socket, :toggle_buy_token, toggle == "true")}
  end

  def handle_event("show-image-modal", %{"image" => image}, socket) do
    {:noreply, assign(socket, :modal_image, image)}
  end

  def handle_event("close-modal", _params, socket) do
    {:noreply, assign(socket, :modal_image, nil)}
  end

  @impl true
  def handle_event(
        "search_orders",
        %{"search_query" => search_query},
        %{assigns: %{orders_data: orders_data}} = socket
      ) do
    # Trim any leading or trailing spaces from the search query
    search_query = String.trim(search_query)

    # Check if the search query is a UUID or ERC20 wallet outside of the guard clause
    orders_data =
      cond do
        search_query == "" ->
          # If the query is empty, return unchanged orders_data
          orders_data

        is_uuid(search_query) ->
          # Fetch orders based on the search_query as a UUID
          fetch_orders(search_query)

        is_erc20_wallet(search_query) ->
          # Fetch orders based on the search_query as an ERC20 wallet
          fetch_orders(search_query)

        true ->
          # Return empty orders if the query is not valid
          %{orders_data | orders: [], selected: nil, total_pages: 1, page: 1}
      end

    # Assign the updated orders_data with the search_query
    {:noreply, assign(socket, orders_data: %{orders_data | search_query: search_query})}
  end

  @impl true
  def handle_event("show-search-results", _params, socket) do
    {:noreply, assign(socket, :show_search_modal, true)}
  end

  @impl true
  def handle_event("close-search-results", _params, socket) do
    {:noreply, assign(socket, :show_search_modal, false)}
  end

  @impl true
  def handle_event(
        "next_page",
        _params,
        %{
          assigns: %{
            orders_data: %{orders: orders, page: page, total_pages: total_pages} = orders_data
          }
        } = socket
      ) do
    if page < total_pages do
      new_page = page + 1

      {:noreply,
       assign(socket,
         orders_data: %{orders_data | page: new_page, selected: move_page(orders, new_page)}
       )}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event(
        "previous_page",
        _params,
        %{assigns: %{orders_data: %{orders: orders, page: page} = orders_data}} = socket
      ) do
    if page > 1 do
      new_page = page - 1

      {:noreply,
       assign(socket,
         orders_data: %{orders_data | page: new_page, selected: move_page(orders, new_page)}
       )}
    else
      {:noreply, socket}
    end
  end

  # Function to fetch orders based on the current page
  defp move_page(orders, page) do
    get_page_orders(orders, page)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="promo-section" class="text-white py-6 sm:py-8 md:py-10 bg-gray-900 relative">
      <!-- Promo Header and Content -->
      <.header_section myself={@myself} />
      <.token_info_section />
      <.call_to_action myself={@myself} toggle_buy_token={@toggle_buy_token} />
      <div class="mt-8 text-center">
        <button
          phx-click="show-search-results"
          phx-target={@myself}
          class="relative bg-gradient-to-br from-gray-900 via-black to-gray-800 text-gray-300 font-semibold py-3 px-6 rounded-full shadow-lg hover:shadow-2xl transition-transform transform hover:scale-105 duration-300 ease-in-out"
        >
          🔍 Search Orders
        </button>
      </div>
      <!-- Search Results Modal -->
      <.live_component
        :if={@show_search_modal}
        id="search-modal"
        module={SearchModal}
        myself={@myself}
        orders_data={@orders_data}
        loading={false}
        error_message={nil}
      />
      <!-- Existing modal and promo components -->
      <%= if @toggle_buy_token do %>
        <.buy_token_modal myself={@myself}>
          <.live_component
            :if={@presale_form.is_confirmed?}
            id="order-info"
            module={OrderInfo}
            order={@order}
            info_visible={false}
          />
          <.live_component
            :if={!@presale_form.is_confirmed?}
            id="order-form"
            module={OrderForm}
            presale_form={@presale_form}
            myself={@myself}
          />
        </.buy_token_modal>
      <% end %>
      <%= if @modal_image do %>
        <.live_component id="image-modal" module={ImageModal} myself={@myself} image={@modal_image} />
      <% end %>
    </div>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <div id="promo-header" class="text-center mb-8">
      <!-- Title -->
      <h1 class="text-2xl sm:text-3xl md:text-4xl font-bold mb-4 text-gray-200 tracking-wide">
        🚀 Ready to Launch into $BIRDPAW?
      </h1>
      <!-- Fun Subheading -->
      <h2 class="text-base sm:text-lg md:text-xl font-medium text-gray-300 mb-6 leading-relaxed max-w-2xl mx-auto">
        Join the $BIRDPAW revolution where agility meets the future of decentralized finance.
      </h2>
      <!-- Images with smaller size and dark rings -->
      <div class="flex justify-center items-center space-x-6 mt-6">
        <img
          src="/images/cat-rocket.webp"
          alt="Cat Rocket"
          class="w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-gray-500 cursor-pointer"
          phx-click="show-image-modal"
          phx-value-image="/images/cat-rocket.webp"
          phx-target={@myself}
        />
        <img
          src="/images/birdpaw-coin.webp"
          alt="BirdPaw Coin"
          class="w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-gray-500 cursor-pointer"
          phx-click="show-image-modal"
          phx-value-image="/images/birdpaw-coin.webp"
          phx-target={@myself}
        />
        <img
          src="/images/cat-hunting-bird.webp"
          alt="Cat Hunting Bird"
          class="w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-gray-500 cursor-pointer"
          phx-click="show-image-modal"
          phx-value-image="/images/cat-hunting-bird.webp"
          phx-target={@myself}
        />
      </div>
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
    <!-- Container with background image and overlay -->
    <div
      id="payment-container"
      phx-click="toggle-buy-token"
      phx-value-toggle="true"
      phx-target={@myself}
      class="relative text-center mt-6 sm:mt-8 rounded-lg overflow-hidden max-w-full"
      style="background-image: url('/images/promo-btn.webp'); background-size: cover; background-position: center;"
    >
      <!-- Dark overlay for contrast -->
      <div class="absolute inset-0 bg-gray-900 bg-opacity-75"></div>
      <!-- Button Content -->
      <div class="relative z-10 py-8 sm:py-12 lg:py-16 px-4 sm:px-6 lg:px-8">
        <button class="bg-gradient-to-r from-purple-500 via-indigo-600 to-teal-500 hover:from-indigo-600 hover:via-purple-700 hover:to-teal-700
          text-white font-bold py-3 px-6 sm:py-4 sm:px-8 lg:py-5 lg:px-10
          rounded-full shadow-lg hover:shadow-xl transition-transform duration-300 transform hover:scale-105
          w-full sm:w-auto tracking-wide text-base sm:text-lg lg:text-xl xl:text-2xl
          max-w-xs sm:max-w-md lg:max-w-lg mx-auto">
          ✨ Exclusive Access to $BIRDPAW - Don't Miss Out!
        </button>
      </div>
      <div class="absolute inset-x-0 bottom-0 h-1 bg-gradient-to-r from-teal-500 via-indigo-600 to-purple-500">
      </div>
    </div>
    """
  end

  defp buy_token_modal(assigns) do
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
