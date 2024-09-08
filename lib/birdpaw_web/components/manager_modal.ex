defmodule BirdpawWeb.Components.ManageOrderModal do
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div class="bg-white p-6 rounded-lg shadow-lg max-w-md w-full">
        <h3 class="text-lg mb-4 text-gray-900 font-bold">Manage Order</h3>

        <p>Order ID: <%= @order.id %></p>

        <form phx-submit="update_order_status">
          <label for="status" class="block mb-2">Change Status:</label>
          <select name="order_state" id="status" class="block w-full px-4 py-2 border rounded mb-4">
            <option value="pending">Pending</option>

            <option value="completed">Completed</option>

            <option value="failed">Failed</option>
          </select>

          <input type="hidden" name="order_id" value={@order.id} />

          <div class="flex justify-end">
            <button
              type="submit"
              class="bg-teal-500 text-white px-4 py-2 rounded-lg hover:bg-teal-600"
            >
              Update
            </button>

            <button
              type="button"
              phx-click="close_manage_modal"
              class="bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600 ml-2"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
    """
  end
end
