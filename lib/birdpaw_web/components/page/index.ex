defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the index page.
  """
  use BirdpawWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       current_slide: 0,
       faqs: [
         {"What is Birdcatcher Cats?",
          "Birdcatcher Cats ($BIRDPAW) is a fun and engaging meme token built on the Ethereum blockchain.",
          "1"},
         {"How can I buy $BIRDPAW?",
          "You can purchase $BIRDPAW on major cryptocurrency exchanges where it is listed.", "2"},
         {"What is the total supply of $BIRDPAW?",
          "$BIRDPAW has a total supply of 1,000,000,000 tokens.", "3"},
         {"What are the future plans for Birdcatcher Cats?",
          "We plan to develop a platform with wallet integration, list on major exchanges, and launch an NFT marketplace.",
          "4"}
       ],
       expanded: false
     )}
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
          <.live_component module={BirdpawWeb.Components.Attributes} id="attributes" />
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

        <div id="tokenomics" class="mt-10">
          <.live_component module={BirdpawWeb.Components.Tokenomics} id="tokenomics" />
        </div>

        <div id="roadmap" class="mt-10">
          <.live_component module={BirdpawWeb.Components.Roadmap} id="roadmap" />
        </div>

        <div id="faq" class="mt-10">
          <.live_component
            module={BirdpawWeb.Components.FAQ}
            id="faq"
            faqs={@faqs}
            expanded={@expanded}
          />
        </div>

        <div id="footer" class="mt-10">
          <.live_component module={BirdpawWeb.Components.Footer} id="footer" />
        </div>
      </div>
    </main>
    """
  end
end
