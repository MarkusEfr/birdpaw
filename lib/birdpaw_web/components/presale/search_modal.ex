defmodule BirdpawWeb.Components.SearchModal do
  use BirdpawWeb, :live_component
  alias BirdpawWeb.Components.OrderTable

  import Birdpaw.PresaleUtil

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="search-modal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-gray-900 bg-opacity-90 transition-opacity duration-300 ease-out sm:p-4 p-2"
    >
      <div class="bg-white text-gray-800 rounded-lg p-4 sm:p-6 w-full max-w-3xl sm:max-w-5xl h-full max-h-full sm:mx-auto shadow-xl relative transform transition-all duration-300 ease-out overflow-auto">
        <!-- Close Button -->
        <button
          phx-click="close-search-results"
          phx-target={@myself}
          class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 transition duration-300"
        >
          ✖
        </button>
        <!-- Modal Title and Badge -->
        <div class="flex items-center justify-center space-x-3 mb-4">
          <img src="/images/new_icon.webp" alt="Cat Icon" class="h-8 sm:h-10 w-8 sm:w-10" />
          <h3 class="text-xl sm:text-2xl font-semibold text-gray-900">
            Search Orders
          </h3>
          <%= if Enum.count(@orders_data.orders) > 0 do %>
            <span class="bg-teal-500 text-white text-xs font-bold px-2 py-1 rounded-full">
              <%= "#{Enum.count(@orders_data.orders)} Found" %>
            </span>
          <% end %>
        </div>
        <!-- Search Form -->
        <form
          phx-submit="search_orders"
          phx-target={@myself}
          class="flex flex-col sm:flex-row mb-4 space-y-2 sm:space-y-0"
        >
          <input
            type="text"
            name="search_query"
            id="search_query"
            class="block w-full sm:flex-grow p-2 sm:p-3 rounded-md bg-gray-100 text-gray-700 border border-gray-300 focus:ring-teal-500 focus:border-teal-500 text-sm sm:text-base placeholder-gray-400"
            placeholder="Order ID or Wallet Address"
            required
          />
          <button
            type="submit"
            class="bg-gradient-to-r from-teal-400 to-blue-500 hover:from-teal-500 hover:to-blue-600 text-white px-4 py-2 sm:px-6 rounded-md shadow-md transition duration-200 text-sm sm:text-base"
          >
            Look Up
          </button>
        </form>
        <!-- Order Table -->
        <%= if Enum.count(@orders_data.orders) > 0 do %>
          <div class="mt-4 sm:mt-6">
            <.live_component
              id="order-table"
              module={OrderTable}
              orders={@orders_data.orders}
              selected={@orders_data.selected}
              index={(@orders_data.page * get_page_size()  - get_page_size())}
            />
          </div>
          <!-- Pagination Controls -->
          <div class="flex justify-between items-center mt-4 sm:mt-6 space-y-2 sm:space-y-0">
            <button
              class="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-md shadow-md transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
              phx-click="previous_page"
              phx-target={@myself}
              disabled={@orders_data.page == 1}
              aria-label="Previous page"
            >
              <!-- Custom Left Arrow SVG -->
              <svg
                class="w-5 h-5"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M12 19c-.6-.6-4-4.4-4-4.4S4 12.5 4 12s4-4.5 4-4.5S11.5 7 12 6.5s4-2 4 2-2.5 4.5-2.5 4.5 4 4.4 4 4.4-2 4-4 4z" />
              </svg>
            </button>
            <span class="text-sm text-gray-500">
              Page <%= @orders_data.page %> of <%= @orders_data.total_pages %>
            </span>
            <button
              class="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-md shadow-md transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
              phx-click="next_page"
              phx-target={@myself}
              disabled={@orders_data.page == @orders_data.total_pages}
              aria-label="Next page"
            >
              <!-- Custom Right Arrow SVG -->
              <svg
                class="w-5 h-5"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M12 5c.6.6 4 4.4 4 4.4S20 11.5 20 12s-4 4.5-4 4.5S12.5 17 12 17.5s-4 2-4-2 2.5-4.5 2.5-4.5-4-4.4-4-4.4 2-4 4-4z" />
              </svg>
            </button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
