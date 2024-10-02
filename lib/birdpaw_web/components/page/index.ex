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
      <!-- Mobile CA Box (only visible on mobile) -->
      <div class="md:hidden bg-yellow-500 text-gray-900 py-2 px-4 text-center font-mono text-sm rounded-lg shadow-md w-full mt-16">
        CA: <%= @contract_address %>
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
          <span class="ml-4 bg-gradient-to-r from-yellow-400 to-orange-500 text-gray-900 py-1 px-4 rounded-lg shadow-md font-mono text-base transition-transform hover:scale-105 hover:bg-yellow-300 hover:text-gray-800">
            CA: <%= @contract_address %>
          </span>
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
    <div class="relative z-10 flex justify-start items-center min-h-screen mx-auto w-full px-4">
      <!-- Left-Side Links Menu with Smoke Shadow Effect (Visible for md and larger screens) -->
      <div class="relative flex flex-col space-y-6 text-left text-yellow-500 font-mono text-2xl md:text-3xl hidden md:flex">
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
      <!-- Content Box that dynamically changes based on menu click -->
      <.content_box id="content" section={@section} />
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
    <div class="md:ml-12 md:p-6 p-4 rounded-lg bg-yellow-100 bg-opacity-70 md:bg-yellow-100 text-gray-900 border-2 border-gray-800 shadow-lg max-w-xl w-full text-center font-mono">
      <%= cond do
        @section == "Home" ->
          "Welcome to Birdpaw! Enjoy the finest experience in meme coins and financial fun!"

        @section == "Tokenomics" ->
          "Explore the full tokenomics of Birdpaw including distribution, rewards, and deflation mechanisms."

        @section == "Roadmap" ->
          "Stay updated on our milestones! The Birdpaw roadmap will guide you through our upcoming developments."

        @section == "Contact" ->
          "Need help? Contact us via our support channels for any inquiries related to Birdpaw."
      end %>
    </div>
    """
  end
end
