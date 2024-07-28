defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the index page.
  """
  use BirdpawWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_slide, 0)}
  end

  @impl true
  def handle_event("prev_slide", _, socket) do
    new_slide = rem(socket.assigns.current_slide - 1 + length(slides()), length(slides()))
    {:noreply, assign(socket, :current_slide, new_slide)}
  end

  @impl true
  def handle_event("next_slide", _, socket) do
    new_slide = rem(socket.assigns.current_slide + 1, length(slides()))
    {:noreply, assign(socket, :current_slide, new_slide)}
  end

  defp slides do
    [
      %{
        src: "/images/meme_1.webp",
        alt: "Almost there!",
        caption: "Almost there!"
      },
      %{
        src: "/images/meme_2.webp",
        alt: "Found it!",
        caption: "Found it!"
      },
      %{
        src: "/images/meme_3.webp",
        alt: "To the moon!",
        caption: "To the moon!"
      }
    ]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-gradient-to-r from-zinc-900 via-zinc-800 to-zinc-900 min-h-screen">
      <div class="mx-auto max-w-6xl p-4">
        <.flash_group flash={@flash} />
        <div
          class="welcome-component bg-cover min-h-screen flex items-center justify-center"
          style="background-image: url('/images/image.webp');"
        >
          <.live_component module={BirdpawWeb.Components.Attributes} id="attributes-section" />
        </div>

        <div
          id="memes"
          class="memes-section bg-gray-800 text-white py-6 md:py-10 mt-10 rounded-lg shadow-lg"
        >
          <h2 class="text-2xl md:text-3xl text-center mb-4 md:mb-6">Fun Memes</h2>

          <div class="relative w-full max-w-lg md:max-w-3xl mx-auto overflow-hidden">
            <div
              class="flex transition-transform duration-500"
              style={"transform: translateX(-#{assigns.current_slide * 100}%);"}
            >
              <%= for slide <- slides() do %>
                <div class="flex-shrink-0 w-full text-center">
                  <img src={slide.src} alt={slide.alt} class="mx-auto max-w-xs md:max-w-md" />
                  <p class="meme-caption text-md md:text-xl mt-2 md:mt-4"><%= slide.caption %></p>
                </div>
              <% end %>
            </div>

            <div class="absolute top-1/2 transform -translate-y-1/2 left-0 ml-2">
              <button
                phx-click="prev_slide"
                class="bg-gray-700 text-white p-2 rounded-full hover:bg-gray-600"
              >
                ‹
              </button>
            </div>

            <div class="absolute top-1/2 transform -translate-y-1/2 right-0 mr-2">
              <button
                phx-click="next_slide"
                class="bg-gray-700 text-white p-2 rounded-full hover:bg-gray-600"
              >
                ›
              </button>
            </div>
          </div>
        </div>
      </div>
       <.live_component module={BirdpawWeb.Components.Tokenomics} id="tokenomics-section" />
    </main>
    """
  end
end
