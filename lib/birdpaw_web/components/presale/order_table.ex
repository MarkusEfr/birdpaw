defmodule BirdpawWeb.Components.OrderTable do
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="w-full text-sm text-left text-gray-700">
        <thead class="text-xs bg-gray-100 text-gray-700 font-semibold uppercase">
          <tr>
            <th class="px-4 py-2">#</th>
            <th class="px-4 py-2">Order ID</th>
            <th class="px-4 py-2">Wallet</th>
            <th class="px-4 py-2">Birdpaw Amount</th>
            <th class="px-4 py-2">Pay Amount</th>
            <th class="px-4 py-2">Payment Method</th>
            <th class="px-4 py-2">Status</th>
            <th class="px-4 py-2">Date</th>
            <th :if={@is_authorized_master} class="px-4 py-2">Manage</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <%= for {order, idx} <- Enum.with_index(@selected, @index + 1) do %>
            <tr class="hover:bg-gray-50 transition duration-150">
              <td class="px-4 py-2 font-medium"><%= idx %></td>
              <td class="px-4 py-2 truncate"><%= order.uuid %></td>
              <td class="px-4 py-2 truncate w-32"><%= order.wallet_address %></td>
              <td class="px-4 py-2 truncate w-32"><%= order.birdpaw_amount %></td>
              <td class="px-4 py-2 text-teal-600"><%= order.amount %></td>
              <td class="px-4 py-2 truncate w-32"><%= order.payment_method %></td>
              <td class="px-4 py-2">
                <span class={"rounded px-2 py-1 text-white " <> status_color(order.order_state)}>
                  <%= order.order_state %>
                </span>
              </td>
              <td class="px-4 py-2 text-gray-500 truncate">
                <%= order.timestamp %>
              </td>

              <td :if={@is_authorized_master} class="px-4 py-2">
                <button
                  phx-click="manage_order"
                  phx-value-order_id={order.uuid}
                  class="text-sm bg-blue-500 text-white px-4 py-2 rounded-lg"
                >
                  Manage
                </button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  # Helper function for the status color
  defp status_color("pending"), do: "bg-yellow-500"
  defp status_color("completed"), do: "bg-green-500"
  defp status_color("failed"), do: "bg-red-500"
  defp status_color(_), do: "bg-gray-400"
end
