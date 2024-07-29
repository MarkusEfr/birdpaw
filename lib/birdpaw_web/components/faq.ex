defmodule BirdpawWeb.Components.FAQ do
  @moduledoc """
  This module is used to render the FAQ page.
  """
  use BirdpawWeb, :live_component

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    new_expanded = if socket.assigns.expanded == id, do: nil, else: id
    {:noreply, assign(socket, :expanded, new_expanded)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="faq-section bg-gray-900 text-white py-16">
      <h2 class="md:text-3xl text-2xl text-center mb-12">Frequently Asked Questions</h2>

      <div class="max-w-6xl mx-auto space-y-8 px-4 md:px-0">
        <%= for {question, answer, id} <- @faqs do %>
          <div class="faq-item bg-gray-800 rounded-lg p-4 md:p-6 shadow-md transition-transform transform hover:scale-105">
            <button
              phx-target={@myself}
              phx-click="toggle"
              phx-value-id={id}
              class="w-full text-left focus:outline-none"
            >
              <div class="flex justify-between items-center">
                <h3 class="text-lg md:text-xl font-semibold flex items-center text-white">
                  <svg
                    class="w-5 h-5 md:w-6 md:h-6 mr-2"
                    fill="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z" />
                  </svg>
                  <%= question %>
                </h3>

                <span class="text-xl text-white">
                  <%= if @expanded == id do %>
                    <svg
                      class="w-5 h-5 md:w-6 md:h-6"
                      fill="currentColor"
                      viewBox="0 0 24 24"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path d="M19 13H5V11H19V13Z" />
                    </svg>
                  <% else %>
                    <svg
                      class="w-5 h-5 md:w-6 md:h-6"
                      fill="currentColor"
                      viewBox="0 0 24 24"
                      xmlns="http://www.w3.org/2000/svg"
                    >
                      <path d="M12 4C7.58 4 4 7.58 4 12C4 16.42 7.58 20 12 20C16.42 20 20 16.42 20 12C20 7.58 16.42 4 12 4ZM12 18C8.69 18 6 15.31 6 12C6 8.69 8.69 6 12 6C15.31 6 18 8.69 18 12C18 15.31 15.31 18 12 18ZM13 13H11V11H13V13ZM13 9H11V7H13V9Z" />
                    </svg>
                  <% end %>
                </span>
              </div>
            </button>

            <div class={"mt-4 text-sm md:text-lg text-gray-100 transition-max-height ease-in-out duration-500 overflow-hidden" <> if @expanded == id, do: " max-h-40", else: " max-h-0"}>
              <%= answer %>
              <span class="ml-2">😺</span>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
