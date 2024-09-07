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
      class="bg-gray-900 text-center rounded-xl p-6 sm:p-8 lg:p-10 shadow-lg max-w-md sm:max-w-lg lg:max-w-2xl mx-auto transition-all duration-300"
    >
      <!-- Title -->
      <p class="text-2xl sm:text-3xl font-semibold text-teal-300 mb-6 tracking-wide uppercase">
        Order Summary
      </p>
      <div class="bg-gray-800 p-4 rounded-md text-teal-300 space-y-2 shadow-sm flex items-start">
        <div class="text-left">
          <p class="text-sm lg:text-base font-medium">
            Your $BIRDPAW tokens will be credited to your wallet within 24 hours after payment is confirmed.
          </p>
        </div>
      </div>
      <!-- Toggle Details Button -->
      <div class="mb-4 mt-4">
        <button
          phx-click="toggle-details"
          phx-target={@myself}
          class="text-teal-400 hover:text-teal-500 font-medium transition-all hover:underline"
        >
          <%= if @info_visible do %>
            Hide Order Details
          <% else %>
            Show Order Details
          <% end %>
        </button>
      </div>
      <!-- Collapsible Order Information -->
      <%= if @info_visible do %>
        <div class="space-y-4 text-left text-gray-300 transition-opacity duration-300">
          <!-- Order ID -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Order ID</p>
            <p class="text-white font-bold"><%= @order.uuid %></p>
          </div>
          <!-- Wallet Address -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Wallet Address</p>
            <p class="text-white font-bold">
              <%= if @order.wallet_address == "", do: "N/A", else: @order.wallet_address %>
            </p>
          </div>
          <!-- Order State -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Order State</p>
            <p class="text-white font-semibold"><%= @order.order_state %></p>
          </div>
          <!-- Amount of BIRDPAW -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Amount of $BIRDPAW</p>
            <p class="text-white font-semibold"><%= @order.birdpaw_amount %></p>
          </div>
          <!-- Amount of Payment -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Amount of <%= @order.payment_method %></p>
            <p class="text-white font-semibold"><%= @order.amount %></p>
          </div>
          <!-- Timestamp -->
          <div class="flex justify-between items-center text-sm sm:text-base space-x-2 py-2 hover:bg-gray-800 hover:shadow-md rounded-md">
            <p class="text-teal-300 font-medium">Timestamp</p>
            <p class="text-white font-semibold"><%= @order.timestamp %></p>
          </div>
        </div>
      <% end %>
      <!-- QR Code with Focus Box -->
      <div class="mt-6 flex justify-center">
        <div class="p-4 bg-gray-800 rounded-lg hover:shadow-2xl transition-all duration-300">
          <img
            src={"data:image/png;base64,#{@order.qr_code_base64}"}
            alt="QR code"
            class="w-28 h-28 sm:w-32 sm:h-32 lg:w-36 lg:h-36 rounded-md ring-1 ring-teal-400"
          />
        </div>
      </div>

      <p class="text-xs sm:text-sm lg:text-base text-gray-400 mt-3">
        Scan the QR code to make the payment.
      </p>
    </div>
    """
  end

  @impl true
  def handle_event("toggle-details", _params, socket) do
    {:noreply, assign(socket, :info_visible, !socket.assigns.info_visible)}
  end
end
