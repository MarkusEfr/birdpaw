defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the redesigned index page with a full-screen background, header, and a full-size sidebar for mobile devices.
  """
  use BirdpawWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       show_mobile_menu: false,
       section: "Home",
       contract_address: "0xDc484b655b157387B493DFBeDbeC4d44A248566F"
     )}
  end

  @impl true
  def handle_event("toggle_menu", _, socket) do
    {:noreply, assign(socket, :show_mobile_menu, !socket.assigns.show_mobile_menu)}
  end

  @impl true
  def handle_event("show_content", %{"section" => section}, socket) do
    # When a section is clicked on mobile, we want to close the menu
    {:noreply,
     socket
     |> assign(:section, section)
     # This closes the menu when a section is selected
     |> assign(:show_mobile_menu, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- Main Section with full-screen background and transparent header -->
    <main class="relative min-h-screen flex flex-col overflow-hidden mx-auto">
      <!-- Header -->
      <.header_section id="header" contract_address={@contract_address} />
      <!-- Full-Size Mobile Sidebar Menu -->
      <.mobile_menu_section id="mobile-menu" show_mobile_menu={@show_mobile_menu} section={@section} />
      <!-- Mobile CA Box with Copy Button -->
      <div class="md:hidden bg-yellow-500 text-gray-900 py-2 px-4 text-center font-mono text-sm rounded-lg shadow-md w-full mt-16 flex justify-center items-center space-x-2">
        <span id="contract-address-mobile">
          CA: <%= @contract_address %>
        </span>
        <!-- Copy Icon for Mobile -->
        <button
          id="copy-btn-mobile"
          class="focus:outline-none bg-transparent hover:bg-yellow-600 hover:text-white transition-colors duration-300 p-2 rounded-md"
          phx-hook="CopyToClipboard"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>

            <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"></path>
          </svg>
        </button>
        <!-- Copied Message for Mobile -->
        <span id="copy-feedback-mobile" class="hidden text-green-400 ml-2">Copied!</span>
      </div>
      <!-- Content Section with Background Image Centered -->
      <section class="relative flex-1 min-h-screen bg-cover bg-center bg-gradient-to-br from-gray-800 via-gray-900 to-gray-800 shadow-lg md:rounded-xl">
        <!-- Background Image Overlay with Centered Image -->
        <div class="absolute inset-0 bg-[url('/images/hero_cat_1_mob.webp')] md:bg-[url('/images/hero_cat_3.webp')] bg-no-repeat bg-center bg-cover">
        </div>
        <!-- Main Content Section for Desktop and Mobile -->
        <.main_content_section section={@section} contract_address={@contract_address} />
      </section>
    </main>
    """
  end

  defp header_section(assigns) do
    ~H"""
    <header class="absolute top-0 left-0 right-0 z-40 bg-gradient-to-r from-gray-900 via-gray-800 to-blue-900 bg-opacity-90 text-white p-4 shadow-lg backdrop-blur-md transition-all ease-in-out duration-300 hover:bg-opacity-100">
      <div class="container mx-auto flex justify-between items-center">
        <!-- Logo with Smooth Effects -->
        <div class="text-3xl font-extrabold tracking-wide text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-orange-500 transition-transform transform hover:scale-110 hover:text-shadow-xl">
          $BIRDPAW
        </div>
        <!-- Desktop Quote with subtle hover effect -->
        <div class="hidden md:flex text-lg text-yellow-300 font-extrabold items-center transition-colors ease-in-out duration-300 hover:text-yellow-400">
          "Catch the bird, ride the Lambo!"
          <!-- Contract Address near Quote (for desktop only) -->
          <div class="ml-4 flex items-center space-x-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-gray-900 py-1 px-4 rounded-lg shadow-md font-mono text-base transition-transform hover:scale-105 hover:bg-yellow-300 hover:text-gray-800">
            <span id="contract-address">
              CA: <%= @contract_address %>
            </span>
            <!-- Copy Icon -->
            <button
              id="copy-btn"
              class="focus:outline-none bg-transparent hover:bg-yellow-600 hover:text-white transition-colors duration-300 p-2 rounded-md"
              phx-hook="CopyToClipboard"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5 w-5"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>

                <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"></path>
              </svg>
            </button>
            <!-- Copied Message -->
            <span id="copy-feedback" class="hidden text-green-400 ml-2">Copied!</span>
          </div>
        </div>
        <!-- Mobile Menu Toggle Button -->
        <button
          class="md:hidden p-2 bg-yellow-500 rounded-md shadow-lg transition-transform transform hover:scale-110 focus:outline-none hover:bg-yellow-400"
          phx-click="toggle_menu"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
        </button>
      </div>
    </header>
    """
  end

  defp main_content_section(assigns) do
    ~H"""
    <div class="relative z-10 flex flex-col justify-start items-start min-h-screen mx-auto w-full px-4 mt-20">
      <!-- Left-Side Links Menu with Smoke Shadow Effect (Visible for md and larger screens) -->
      <div class="relative flex flex-col space-y-6 text-left text-yellow-500 font-mono text-2xl md:text-3xl hidden md:flex ml-10">
        <!-- Smoke Shadow Effect -->
        <div class="absolute inset-0 opacity-60 rounded-md bg-gray-900 blur-lg -z-10"></div>
        <!-- Links with SVG Icons -->
        <a
          href="#"
          phx-click="show_content"
          phx-value-section="Home"
          class="flex items-center hover:text-yellow-300 hover:scale-105 transition-transform"
        >
          <img src="/images/menu/4.png" class="h-12 w-12 mr-2" alt="cat icon" /> Home
        </a>

        <a
          href="#"
          phx-click="show_content"
          phx-value-section="Tokenomics"
          class="flex items-center hover:text-yellow-300 hover:scale-105 transition-transform"
        >
          <img src="/images/menu/2.png" class="h-12 w-12 mr-2" alt="scroll icon" /> Tokenomics
        </a>

        <a
          href="#"
          phx-click="show_content"
          phx-value-section="Roadmap"
          class="flex items-center hover:text-yellow-300 hover:scale-105 transition-transform"
        >
          <img src="/images/menu/3.png" class="h-12 w-12 mr-2" alt="roadmap icon" /> Roadmap
        </a>

        <a
          href="#"
          phx-click="show_content"
          phx-value-section="Contact"
          class="flex items-center hover:text-yellow-300 hover:scale-105 transition-transform"
        >
          <img src="/images/menu/1.png" class="h-12 w-12 mr-2" alt="contact icon" /> Contact
        </a>
      </div>
      <.notice_section />
    </div>
    """
  end

  defp notice_section(assigns) do
    ~H"""
    <!-- Retro old-panel style notice section -->
    <div class="hidden md:block max-w-2xl ml-6 bg-gray-900 text-gray-100 border border-gray-700 rounded-md shadow-lg p-6 mt-6 mb-6 relative">
      <!-- Old-school panel background effect -->
      <div class="absolute inset-0 bg-gray-800 bg-opacity-70 rounded-md shadow-inner"></div>
      <!-- Meme-style, witty Notice Content -->
      <div class="relative z-10">
        <h2 class="text-lg font-bold text-yellow-300 mb-3 tracking-wider">
          Birdcatcher Cats: Pounce, Profit, Repeat!
        </h2>
        <p class="text-sm text-gray-300 leading-relaxed mb-4">
          In the crypto jungle, only the coolest cats catch the fattest birds. No rush. No FOMO. Just vibe, wait, and strike when the bird flies close enough to grab with your paws.
        </p>
        <p class="text-sm text-gray-300 leading-relaxed mb-4">
          Catch a bird? Congrats, you’re one Lambo closer to flexing on Twitter. Miss one? Meh, more birds will fly by. The hustle never stops, but the chill cats win.
        </p>
        <p class="text-sm text-gray-300 leading-relaxed">
          So sharpen those claws, keep your shades on, and get ready for the next flight. The market’s wild, but cats like you? You’re wilder. 🐾
        </p>
      </div>
      <!-- Beveled edges and retro inset shadow for the panel -->
      <div class="absolute inset-0 z-0 border-gray-600 rounded-md bg-gray-700 shadow-lg pointer-events-none">
      </div>
    </div>
    """
  end

  defp mobile_menu_section(assigns) do
    ~H"""
    <nav class={"fixed inset-0 z-50 bg-gray-900 bg-opacity-90 text-white transform transition-transform duration-300 ease-in-out #{if @show_mobile_menu, do: 'translate-y-0', else: '-translate-y-full'} md:hidden"}>
      <div class="absolute top-0 right-0 p-4">
        <!-- Close Button -->
        <button
          class="text-gray-100 bg-gray-800 bg-opacity-70 rounded-full p-2 shadow-lg"
          phx-click="toggle_menu"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>
      <!-- Mobile Menu Content (Full Screen) -->
      <div class="flex flex-col justify-center items-center h-full space-y-8 text-2xl">
        <h2 class="text-3xl font-bold text-yellow-300">"Profit is for the Fast"</h2>

        <ul class="flex flex-col justify-start items-start space-y-4 text-lg font-mono">
          <li>
            <a
              href="#"
              phx-click="show_content"
              phx-value-section="Home"
              class="flex items-center py-2 px-4 text-yellow-400 hover:bg-gray-700 rounded-md"
            >
              <img src="/images/menu/4.png" class="h-10 w-10 mr-2" alt="cat icon" /> Home
            </a>
          </li>

          <li>
            <a
              href="#"
              phx-click="show_content"
              phx-value-section="Tokenomics"
              class="flex items-center py-2 px-4 text-yellow-400 hover:bg-gray-700 rounded-md"
            >
              <img src="/images/menu/2.png" class="h-10 w-10 mr-2" alt="scroll icon" /> Tokenomics
            </a>
          </li>

          <li>
            <a
              href="#"
              phx-click="show_content"
              phx-value-section="Roadmap"
              class="flex items-center py-2 px-4 text-yellow-400 hover:bg-gray-700 rounded-md"
            >
              <img src="/images/menu/3.png" class="h-10 w-10 mr-2" alt="roadmap icon" /> Roadmap
            </a>
          </li>

          <li>
            <a
              href="#"
              phx-click="show_content"
              phx-value-section="Contact"
              class="flex items-center py-2 px-4 text-yellow-400 hover:bg-gray-700 rounded-md"
            >
              <img src="/images/menu/1.png" class="h-10 w-10 mr-2" alt="contact icon" /> Contact
            </a>
          </li>
        </ul>
      </div>
    </nav>
    """
  end

  defp content_box(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center space-y-6 mx-6">
      <%= cond do
        @section == "Home" -> render_home_content(assigns)
        @section == "Tokenomics" -> render_tokenomics_content(assigns)
        @section == "Roadmap" -> render_roadmap_content(assigns)
        @section == "Contact" -> render_contact_content(assigns)
      end %>
    </div>
    """
  end

  defp render_home_content(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-6">
      <!-- Home Cards -->
      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <img class="w-full" src="/images/card_home_1.png" alt="Home Card 1" />
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Welcome to Birdpaw</div>
          <p class="text-gray-700 text-base">Join the most exciting meme coin in the universe.</p>
        </div>
      </div>

      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <img class="w-full" src="/images/card_home_2.png" alt="Home Card 2" />
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Exclusive Benefits</div>
          <p class="text-gray-700 text-base">Holders gain access to unique rewards and features.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_tokenomics_content(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-6">
      <!-- Tokenomics Cards -->
      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Total Supply</div>
          <p class="text-gray-700 text-base">1,000,000,000 $BIRDPAW</p>
        </div>
      </div>

      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Distribution</div>
          <p class="text-gray-700 text-base">
            50% Public Sale, 25% Reserved, 15% Development, 10% Marketing.
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp render_roadmap_content(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-6">
      <!-- Roadmap Cards -->
      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Phase 1: Launch</div>
          <p class="text-gray-700 text-base">Token launch and community growth.</p>
        </div>
      </div>

      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Phase 2: Listing</div>
          <p class="text-gray-700 text-base">Get listed on major exchanges.</p>
        </div>
      </div>
    </div>
    """
  end

  defp render_contact_content(assigns) do
    ~H"""
    <div class="flex flex-col items-center space-y-6">
      <!-- Contact Info Card -->
      <div class="max-w-sm rounded-lg overflow-hidden shadow-lg bg-white p-4">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">Get in Touch</div>
          <p class="text-gray-700 text-base">
            Contact us via Twitter or Medium for more info about $BIRDPAW.
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp preview_text, do: @preview_text
end
