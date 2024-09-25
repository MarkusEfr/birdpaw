defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the redesigned index page.
  """
  use BirdpawWeb, :live_view

  def render(assigns) do
    ~H"""
    <!-- Main Section with hooks for floating text and scroll reveal -->
    <main class="relative min-h-screen bg-gradient-to-br from-blue-500 to-purple-700 text-gray-900">
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
        <h1 class="text-6xl md:text-8xl font-extrabold tracking-tight mb-4 text-transparent bg-clip-text
                   bg-gradient-to-r from-pink-500 via-purple-500 to-blue-500 drop-shadow-lg">
          Maximize Your Profits with $BIRDPAW!
        </h1>
        <!-- Subheadline/Tagline with shadow -->
        <p class="text-xl md:text-3xl mb-8 text-white drop-shadow-lg">
          Revolutionizing Memes with Profits in Mind
        </p>
        <!-- CTA Button -->
        <button class="bg-pink-500 hover:bg-pink-600 text-white py-3 px-8 rounded-full text-xl font-bold
                       transition-transform duration-300 ease-in-out transform hover:scale-105">
          Get $BIRDPAW Now
        </button>
      </div>
      <!-- Scroll reveal animation on tokenomics section -->
      <.tokenomics_section id="tokenomics" />
    </main>
    """
  end

  defp tokenomics_section(assigns) do
    ~H"""
    <section class="mt-16 flex justify-center items-center">
      <!-- Container for Tokenomics boxes -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8 p-8 w-full max-w-7xl">
        <!-- Total Supply Box -->
        <div class="token-box bg-gradient-to-r from-pink-500 to-purple-500 border-2 border-pink-300
                        rounded-lg p-8 text-center shadow-xl transform transition-all hover:scale-105">
          <div class="text-3xl mb-4">
            <img src="/images/attributes/1.png" alt="Total Supply" class="w-12 h-12 mx-auto" />
          </div>
          <h3 class="text-xl font-bold text-white">Total Supply</h3>
          <p class="text-gray-300 mt-2">1,000,000,000 $BIRDPAW tokens</p>
        </div>
        <!-- Ethereum Network Box -->
        <div class="token-box bg-gradient-to-r from-green-400 to-blue-500 border-2 border-green-300
                        rounded-lg p-8 text-center shadow-xl transform transition-all hover:scale-105">
          <div class="text-3xl mb-4">
            <img src="/images/attributes/2.png" alt="Ethereum Network" class="w-12 h-12 mx-auto" />
          </div>
          <h3 class="text-xl font-bold text-white">Ethereum Network</h3>
          <p class="text-gray-300 mt-2">Built on the secure ERC-20 standard</p>
        </div>
        <!-- Liquidity Locked Box -->
        <div class="token-box bg-gradient-to-r from-yellow-500 to-orange-500 border-2 border-yellow-300
                        rounded-lg p-8 text-center shadow-xl transform transition-all hover:scale-105">
          <div class="text-3xl mb-4">
            <img src="/images/attributes/3.png" alt="Liquidity Locked" class="w-12 h-12 mx-auto" />
          </div>
          <h3 class="text-xl font-bold text-white">Liquidity Locked</h3>
          <p class="text-gray-300 mt-2">Locked for security and transparency</p>
        </div>
        <!-- $BIRDPAW Symbol Box -->
        <div class="token-box bg-gradient-to-r from-purple-600 to-indigo-500 border-2 border-purple-300
                        rounded-lg p-8 text-center shadow-xl transform transition-all hover:scale-105">
          <div class="text-3xl mb-4">
            <img src="/images/attributes/4.png" alt="$BIRDPAW Symbol" class="w-12 h-12 mx-auto" />
          </div>
          <h3 class="text-xl font-bold text-white">$BIRDPAW Symbol</h3>
          <p class="text-gray-300 mt-2">$BIRDPAW is ready to soar</p>
        </div>
      </div>
    </section>
    """
  end
end
