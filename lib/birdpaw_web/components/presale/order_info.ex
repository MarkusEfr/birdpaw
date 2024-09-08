defmodule BirdpawWeb.Components.OrderInfo do
  @moduledoc """
  This module renders the OrderInfo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="order-info"
      class="bg-gray-900 text-center rounded-xl p-4 sm:p-6 lg:p-8 shadow-lg max-w-md sm:max-w-lg lg:max-w-2xl mx-auto transition-all duration-300"
    >
      <!-- Title -->
      <p class="text-lg sm:text-xl lg:text-2xl font-semibold text-teal-300 mb-4 tracking-wide uppercase">
        Order Summary
      </p>
      <!-- Notice -->
      <div class="bg-gray-800 p-3 rounded-md text-teal-300 space-y-2 shadow-sm flex items-start mb-3">
        <div class="text-left">
          <p class="text-xs lg:text-sm font-medium leading-tight">
            Your $BIRDPAW tokens will be credited to your wallet within 24 hours after payment is confirmed.
          </p>
        </div>
      </div>
      <!-- Toggle Details Button -->
      <div class="mb-3">
        <button
          phx-click="toggle-details"
          phx-target={@myself}
          class="text-teal-400 hover:text-teal-500 font-medium text-sm transition-all hover:underline"
        >
          <%= if @info_visible do %>
            Hide Order Details
          <% else %>
            Show Order Details
          <% end %>
        </button>
      </div>
      <!-- Collapsible Order Information with Compact Styling -->
      <%= if @info_visible do %>
        <div class="space-y-2 sm:space-y-3 text-left text-gray-300 transition-opacity duration-300">
          <!-- Order ID -->
          <div
            class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-1 sm:py-2 hover:bg-gray-800 hover:shadow-md rounded-md w-full"
            phx-click="select-field"
            phx-value-field="order_id"
            phx-target={@myself}
          >
            <p class="text-teal-300 font-medium">Order ID</p>
            <p class="text-white font-bold w-full break-all truncate overflow-wrap overflow-x-auto hover:whitespace-normal break-all">
              <%= @order.uuid %>
            </p>
          </div>
          <!-- Wallet Address -->
          <div
            class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-1 sm:py-2 hover:bg-gray-800 hover:shadow-md rounded-md w-full"
            phx-click="select-field"
            phx-value-field="wallet_address"
            phx-target={@myself}
          >
            <p class="text-teal-300 font-medium">Wallet Address</p>
            <p class="text-white font-bold w-full break-all truncate overflow-wrap overflow-x-auto hover:whitespace-normal break-all">
              <%= if assigns[:selected_field] == :wallet_address && @order.wallet_address != "",
                do: @order.wallet_address,
                else: if(@order.wallet_address == "", do: "N/A", else: @order.wallet_address) %>
            </p>
          </div>
          <!-- Other Fields (Order State, Amount of BIRDPAW, etc.) -->
          <div class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Order State</p>
            <p class="text-white font-semibold"><%= @order.order_state %></p>
          </div>

          <div class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Amount of $BIRDPAW</p>
            <p class="text-white font-semibold"><%= @order.birdpaw_amount %></p>
          </div>

          <div class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Amount of <%= @order.payment_method %></p>
            <p class="text-white font-semibold"><%= @order.amount %></p>
          </div>

          <div class="flex justify-between items-center text-xs sm:text-sm space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Timestamp</p>
            <p class="text-white font-semibold"><%= @order.timestamp %></p>
          </div>
        </div>
      <% end %>
      <!-- QR Code with Focus Box -->
      <div class="mt-4 sm:mt-5 flex justify-center">
        <div class="p-3 bg-gray-800 rounded-lg hover:shadow-2xl transition-all duration-300">
          <img
            src={"data:image/png;base64,#{@order.qr_code_base64}"}
            alt="QR code"
            class="w-24 h-24 sm:w-28 sm:h-28 lg:w-32 lg:h-32 rounded-md ring-1 ring-teal-400"
          />
        </div>
      </div>

      <p class="text-xs sm:text-sm text-gray-400 mt-2 sm:mt-3">
        Scan the QR code to make the payment.
      </p>
    </div>
    """
  end

  @impl true
  def handle_event("toggle-details", _params, socket) do
    {:noreply, assign(socket, :info_visible, !socket.assigns.info_visible)}
  end

  @impl true
  def handle_event("select-field", %{"field" => field}, socket) do
    {:noreply, assign(socket, :selected_field, String.to_atom(field))}
  end
end
