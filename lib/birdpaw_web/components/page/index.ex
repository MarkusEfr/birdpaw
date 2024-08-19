defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the index page.
  """
  use BirdpawWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :auto_slide, 5000)

    {:ok,
     assign(socket,
       current_slide: 0,
       faqs: [
         {"What is Birdcatcher Cats?",
          "Birdcatcher Cats ($BIRDPAW) is a fun and engaging meme token built on the Ethereum blockchain.",
          "1", nil},
         {"How can I buy $BIRDPAW?",
          "You can purchase $BIRDPAW on major cryptocurrency exchanges where it is listed.", "2",
          nil},
         {"What is the total supply of $BIRDPAW?",
          "$BIRDPAW has a total supply of 1,000,000,000 tokens.", "3", nil},
         {"What are the future plans for Birdcatcher Cats?",
          "We plan to develop a platform with wallet integration, list on major exchanges, and launch an NFT marketplace.",
          "4", nil},
         {"Where can I read the whitepaper?",
          "You can find the Birdcatcher Cats ($BIRDPAW) whitepaper at ", "5", :whitepaper}
       ],
       expanded: false,
       # Replace with your actual contract address
       contract_address: "0x32e4A492068beE178A42382699DBBe8eEF078800"
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

  @impl true
  def handle_event("copy_address", %{"address" => address}, socket) do
    {:noreply, push_event(socket, "copy_to_clipboard", %{address: address})}
  end

  @impl true
  def handle_info(:auto_slide, socket) do
    new_slide = rem(socket.assigns.current_slide + 1, length(slides()))
    # 5 seconds interval
    Process.send_after(self(), :auto_slide, 5000)
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
      },
      %{
        src: "/images/meme_5.webp",
        alt: "Catch the bird!",
        caption: "Catch the bird!"
      },
      %{
        src: "/images/meme_6.webp",
        alt: "Catching profits!",
        caption: "Catching profits!"
      },
      %{
        src: "/images/meme_7.webp",
        alt: "Feather your nest",
        caption: "Feather your nest!"
      }
    ]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-gradient-to-r from-zinc-900 via-zinc-800 to-zinc-900 min-h-screen">
      <div class="mx-auto max-w-6xl p-4">
        <div
          class="welcome-component bg-cover min-h-screen flex items-center justify-center"
          style="background-image: url('/images/image.webp');"
        >
          <.live_component
            module={BirdpawWeb.Components.Attributes}
            id="attributes"
            contract_address={@contract_address}
          />
        </div>
         <.live_component module={BirdpawWeb.Components.Promo} id="promo" />
        <div
          id="memes"
          class="memes-section bg-gray-800 text-white py-6 md:py-10 mt-10 rounded-lg shadow-lg"
        >
          <h2 class="text-2xl md:text-3xl text-center mb-6 md:mb-10">Gallery</h2>
          
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
        
        <div class="mt-10">
          <.live_component module={BirdpawWeb.Components.Tokenomics} id="tokenomics" />
        </div>
        
        <div class="mt-10">
          <.live_component module={BirdpawWeb.Components.Roadmap} id="roadmap" />
        </div>
        
        <div class="mt-10">
          <.live_component
            module={BirdpawWeb.Components.FAQ}
            id="faq"
            faqs={@faqs}
            expanded={@expanded}
          />
        </div>
        
        <div id="footer">
          <.live_component module={BirdpawWeb.Components.Footer} id="footer" />
        </div>
      </div>
    </main>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        setInterval(() => {
          const memesElement = document.getElementById("memes");
          if (memesElement) {
            const pushEvent = memesElement.__phx__ ? memesElement.__phx__.pushEvent : null;
            if (pushEvent) {
              pushEvent.call(memesElement, "next_slide", {});
            }
          }
        }, 5000);

        const copyButton = document.getElementById("copy-button");
        const contractAddress = document.getElementById("contract-address").innerText;

        copyButton.addEventListener("click", () => {
          navigator.clipboard.writeText(contractAddress).then(
            () => {
              alert("Contract address copied to clipboard!");
            },
            (err) => {
              console.error("Could not copy text: ", err);
            }
          );
        });
      });
    </script>
    """
  end
end
