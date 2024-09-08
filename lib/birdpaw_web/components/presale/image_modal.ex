defmodule BirdpawWeb.Components.ImageModal do
  use BirdpawWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id="image-modal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-75 transition-opacity duration-300 ease-out"
    >
      <div class="relative bg-white rounded-lg shadow-lg overflow-hidden max-w-full max-h-full p-4 sm:p-6">
        <img src={@image} class="max-w-full max-h-full rounded-lg" alt="Full-size image" />
        <button
          phx-click="close-modal"
          phx-target={@myself}
          class="absolute top-3 right-3 text-gray-600 hover:text-gray-800"
        >
          ✖
        </button>
      </div>
    </div>
    """
  end
end
