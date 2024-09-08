defmodule BirdpawWeb.Components.OrderRow do
  use BirdpawWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="relative bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300 p-4 flex justify-between items-center border-l-4 border-indigo-500">
      <!-- Left Side: Order Information -->
      <div class="flex flex-col space-y-1 text-sm">
        <!-- Order ID -->
        <div class="flex items-center space-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4 text-indigo-400"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <path d="M5 12h14M5 12l5-5m-5 5l5 5" />
          </svg>
           <span class="font-semibold text-gray-700">Order ID:</span>
          <span class="truncate text-gray-600"><%= @order.uuid %></span>
        </div>
        <!-- Wallet Address -->
        <div class="flex items-center space-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4 text-blue-400"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <path d="M5 12h14M5 12l5-5m-5 5l5 5" />
          </svg>
           <span class="font-semibold text-gray-700">Wallet:</span>
          <span class="truncate text-blue-500"><%= @order.wallet_address %></span>
        </div>
        <!-- Amount -->
        <div class="flex items-center space-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4 text-green-400"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <path d="M12 8v4m-4 0h8m-8 0l4-4m-4 4l4 4" />
          </svg>
           <span class="font-semibold text-gray-700">Amount:</span>
          <span class="text-green-500"><%= @order.amount %> $BIRDPAW</span>
        </div>
        <!-- Status -->
        <div class="flex items-center space-x-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4 text-yellow-400"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <path d="M5 12h14" />
          </svg>
           <span class="font-semibold text-gray-700">Status:</span>
          <span class="text-yellow-500"><%= @order.order_state %></span>
        </div>
      </div>
      <!-- Right Side: Action Button -->
      <div>
        <button class="bg-gradient-to-r from-indigo-500 to-blue-500 text-white text-xs px-4 py-2 rounded-full shadow hover:shadow-lg hover:scale-105 transition-transform duration-300">
          View Details
        </button>
      </div>
    </div>
    """
  end
end
