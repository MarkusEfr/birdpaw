defmodule BirdpawWeb.Components.OrderInfo do
  @moduledoc """
  This module renders the OrderInfo component for the Birdpaw token presale.
  It handles user interactions such as toggling the buy modal, calculating
  the required ETH for a given $BIRDPAW amount, and generating a QR code
  for payment.
  """
  use BirdpawWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="text-center bg-gray-900 rounded-lg p-6 sm:p-4 shadow-lg">
      <p class="text-xl sm:text-2xl font-bold text-teal-400 mb-6">Order Confirmed!</p>

      <div class="bg-gray-800 rounded-lg p-4 shadow-md mb-4">
        <p class="text-xs sm:text-sm font-medium text-teal-400 uppercase tracking-wide">Order ID</p>

        <p class="text-sm sm:text-base text-white truncate"><%= @order.uuid %></p>
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

      <img src={"data:image/png; base64, #{@order.qr_code_base64}"} alt="QR code" class="shadow-lg mx-auto" />
      <p class="text-xs sm:text-sm text-gray-400 mt-4">Scan the QR code to make the payment.</p>
    </div>
    """
  end
end
