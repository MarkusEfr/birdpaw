defmodule BirdpawWeb.Components.MasterModal do
  use BirdpawWeb, :live_component

  alias Birdpaw.SecurityUtil

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
      <div class="bg-white p-6 rounded-lg shadow-lg max-w-md w-full">
        <h3 class="text-lg mb-4 text-gray-900 font-bold">Enter Master Password</h3>
        <%= if @error_message do %>
          <div class="text-red-500 mb-4"><%= @error_message %></div>
        <% end %>
        <form phx-submit="verify_password" phx-target={@myself}>
          <input
            type="password"
            name="master_password"
            class="block w-full px-4 py-2 border rounded mb-4 focus:ring-teal-500 focus:border-teal-500"
            placeholder="Master Password"
            required
          />
          <div class="flex justify-end">
            <button
              type="submit"
              class="bg-teal-500 text-white px-4 py-2 rounded-lg hover:bg-teal-600"
            >
              Submit
            </button>
            <button
              phx-click="close_modal"
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

  @impl true
  def handle_event("verify_password", %{"master_password" => entered_password}, socket) do
    # Get the hashed password from the environment variable
    stored_hash = Application.get_env(:birdpaw, :master_password_hash)

    if SecurityUtil.verify_master_password(entered_password, stored_hash) do
      send(self(), :close_master_modal)
      {:noreply, assign(socket, :password_verified, true)}
    else
      {:noreply, assign(socket, :error_message, "Invalid password")}
    end
  end
end
