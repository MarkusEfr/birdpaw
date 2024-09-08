defmodule BirdpawWeb.Components.OrderRow do
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <tr>
      <td class="px-4 py-2"><%= @order.id %></td>
      <td class="px-4 py-2"><%= @order.wallet_address %></td>
      <td class="px-4 py-2 text-teal-600"><%= @order.amount %></td>
      <td class="px-4 py-2">
        <button
          phx-click="show-password-modal"
          phx-target={@myself}
          class="text-sm bg-blue-500 text-white px-4 py-2 rounded-lg"
        >
          Manage
        </button>
      </td>
    </tr>
    <!-- Password Modal -->
    <%= if @show_password_modal do %>
      <div
        id="password-modal"
        class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div class="bg-white p-6 rounded-lg shadow-lg">
          <h3 class="text-lg mb-4">Enter Master Password</h3>
          <form phx-submit="verify_password" phx-target={@myself}>
            <input
              type="password"
              name="master_password"
              class="block w-full px-4 py-2 border rounded"
              placeholder="Master Password"
            />
            <button type="submit" class="mt-4 bg-green-500 text-white px-4 py-2 rounded-lg">
              Submit
            </button>
          </form>
        </div>
      </div>
    <% end %>
    """
  end
end
