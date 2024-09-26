defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the redesigned index page.
  """
  use BirdpawWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(contract_address: "0x32e4A492068beE178A42382699DBBe8eEF078800")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- Main Section with hooks for floating text and scroll reveal -->
    <main class="relative min-h-screen bg-gradient-to-br from-blue-800 to-orange-600 text-gray-100">
      <!-- Bubble Background Animation -->
      <!-- Moving Bird Animation -->
      <div id="bird-container" class="fixed bottom-4 right-4 z-50" phx-hook="BirdAnimation">
        <img src="/images/bird1.png" id="bird" class="bird w-24 h-24" />
      </div>
      <div class="absolute inset-0 overflow-hidden">
        <div class="bubble bubble1"></div>
        <div class="bubble bubble2"></div>
        <div class="bubble bubble3"></div>
      </div>
      <!-- Floating Hero Section with FloatingText hook -->
      <div
        class="relative flex flex-col items-center justify-center text-center min-h-screen p-6 z-10"
        phx-hook="FloatingText"
        id="home"
      >
        <!-- Headline with enhanced visibility -->
        <h1 class="text-5xl md:text-7xl font-extrabold tracking-tight mb-4 text-transparent bg-clip-text
                   bg-gradient-to-r from-cyan-400 via-pink-500 to-orange-500 drop-shadow-lg">
          Maximize Your Profits with $BIRDPAW!
        </h1>
        <!-- Subheadline/Tagline with shadow -->
        <p class="text-xl md:text-3xl mb-8 text-gray-100 drop-shadow-lg">
          Revolutionizing Memes with Profits in Mind
        </p>
        <!-- CTA Button -->
        <button class="bg-orange-500 hover:bg-orange-600 text-white py-3 px-6 rounded-full text-lg md:text-xl font-bold
                       transition-transform duration-300 ease-in-out transform hover:scale-105">
          Get $BIRDPAW Now
        </button>
      </div>
      <!-- Contract Address Section -->
      <section class="absolute top-8 left-0 right-0 text-center bg-gradient-to-r from-yellow-400 via-orange-500 to-pink-500 py-3 shadow-md">
        <h2 class="text-sm md:text-lg font-semibold text-gray-900">Contract Address:</h2>
        <div class="flex justify-center items-center gap-2 mt-1">
          <p
            id="contract-address"
            class="text-sm md:text-lg text-gray-900 font-mono truncate w-full max-w-xs md:max-w-md"
          >
            <%= @contract_address %>
          </p>
          <!-- Copy Icon -->
          <button
            id="copy-ca"
            class="text-gray-900 focus:outline-none hover:text-orange-600 transition-all"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5 md:h-6 md:w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M8 7H5a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-3M16 5h3m-3 0v3m0-3l-5 5"
              />
            </svg>
          </button>
        </div>
      </section>
      <!-- Tokenomics Section -->
      <.tokenomics_section id="tokenomics" />
    </main>
    """
  end

  defp tokenomics_section(assigns) do
    ~H"""
    <section class="mt-16 flex flex-col justify-center items-center">
      <!-- Container for Tokenomics boxes -->
      <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4 p-6 w-full max-w-7xl">
        <!-- Total Supply Box -->
        <div class="token-box bg-white border border-gray-200 rounded-lg p-6 text-center shadow-lg transform transition-all hover:scale-105">
          <div class="text-2xl mb-3">
            <img src="/images/attributes/1.png" alt="Total Supply" class="w-10 h-10 mx-auto" />
          </div>
          <h3 class="text-lg md:text-xl font-semibold text-gray-900">Total Supply</h3>
          <p class="text-gray-700 mt-2">1,000,000,000 $BIRDPAW tokens</p>
          <p class="text-sm mt-2 text-gray-500">A meme coin with real value.</p>
        </div>
        <!-- Ethereum Network Box -->
        <div class="token-box bg-white border border-gray-200 rounded-lg p-6 text-center shadow-lg transform transition-all hover:scale-105">
          <div class="text-2xl mb-3">
            <img src="/images/attributes/2.png" alt="Ethereum Network" class="w-10 h-10 mx-auto" />
          </div>
          <h3 class="text-lg md:text-xl font-semibold text-gray-900">Ethereum Network</h3>
          <p class="text-gray-700 mt-2">Built on the secure ERC-20 standard</p>
          <p class="text-sm mt-2 text-gray-500">Powered by Ethereum’s decentralized tech.</p>
        </div>
        <!-- Liquidity Locked Box -->
        <div class="token-box bg-white border border-gray-200 rounded-lg p-6 text-center shadow-lg transform transition-all hover:scale-105">
          <div class="text-2xl mb-3">
            <img src="/images/attributes/3.png" alt="Liquidity Locked" class="w-10 h-10 mx-auto" />
          </div>
          <h3 class="text-lg md:text-xl font-semibold text-gray-900">Liquidity Locked</h3>
          <p class="text-gray-700 mt-2">Locked for security and transparency</p>
          <p class="text-sm mt-2 text-gray-500">Ensuring stability and long-term growth.</p>
        </div>
        <!-- $BIRDPAW Symbol Box -->
        <div class="token-box bg-white border border-gray-200 rounded-lg p-6 text-center shadow-lg transform transition-all hover:scale-105">
          <div class="text-2xl mb-3">
            <img src="/images/attributes/4.png" alt="$BIRDPAW Symbol" class="w-10 h-10 mx-auto" />
          </div>
          <h3 class="text-lg md:text-xl font-semibold text-gray-900">$BIRDPAW Symbol</h3>
          <p class="text-gray-700 mt-2">$BIRDPAW is ready to soar</p>
          <p class="text-sm mt-2 text-gray-500">Join the meme revolution today!</p>
        </div>
      </div>
    </section>
    """
  end
end
