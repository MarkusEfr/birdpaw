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
          <.render_attributes />
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
    </main>
    """
  end

  def render_attributes(assigns) do
    ~H"""
    <div class="overlay bg-black bg-opacity-70 w-full h-full flex flex-col items-center justify-center text-white p-4 md:p-8">
      <div class="bg-gray-800 bg-opacity-50 rounded-lg p-6 md:p-10 max-w-lg md:max-w-3xl text-center shadow-lg backdrop-filter backdrop-blur-sm border border-gray-700 animate-fadeInUp">
        <h1 class="title text-3xl md:text-5xl font-extrabold mb-2 md:mb-4 text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-500">
          Birdcatcher Cats (BIRDPAW)
        </h1>
        
        <h2 class="subtitle text-lg md:text-2xl font-semibold mb-4 md:mb-6 text-shadow-lg">
          Join the Hunt for Fun and Profit!
        </h2>
        
        <div class="token-parameters grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 md:mb-6">
          <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
            <img src="/images/attributes/1.png" alt="Name Icon" class="w-12 h-12" />
            <div>
              <p class="font-bold text-lg">Name:</p>
              
              <p class="text-md">Birdcatcher Cats</p>
            </div>
          </div>
          
          <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
            <img src="/images/attributes/2.png" alt="Symbol Icon" class="w-12 h-12" />
            <div>
              <p class="font-bold text-lg">Symbol:</p>
              
              <p class="text-md">BIRDPAW</p>
            </div>
          </div>
          
          <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
            <img src="/images/attributes/3.png" alt="Total Supply Icon" class="w-12 h-12" />
            <div>
              <p class="font-bold text-lg">Total Supply:</p>
              
              <p class="text-md">1,000,000,000 BIRDPAW</p>
            </div>
          </div>
          
          <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
            <img src="/images/attributes/4.png" alt="Network Icon" class="w-12 h-12" />
            <div>
              <p class="font-bold text-lg">Network:</p>
              
              <p class="text-md">Ethereum (ERC-20)</p>
            </div>
          </div>
        </div>
        
        <button class="buy-button bg-orange-500 hover:bg-orange-600 text-white font-bold py-2 px-4 rounded-full text-lg md:text-2xl transition duration-300 ease-in-out transform hover:scale-105 mt-4">
          Buy BIRDPAW
        </button>
      </div>
    </div>
    """
  end
end
