defmodule BirdpawWeb.Components.Promo do
  @moduledoc """
  This module is used to render the Promo component for the Birdpaw token presale.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="promo-section"
      phx-hook="PromoAnimation"
      class="bg-cover bg-no-repeat text-white py-16 sm:py-12 md:py-20 lg:py-24"
      style="background-image: url('/images/birdpaw-treasure-bg.png');"
    >
      <!-- Header Section -->
      <div id="promo-header" class="text-center mb-12 opacity-0 transition-opacity duration-1000">
        <h1 class="text-4xl sm:text-5xl md:text-6xl font-extrabold mb-4 animate-text-rotate">
          🎉 Welcome to the $BIRDPAW Presale! 🎉
        </h1>
        <p class="text-lg sm:text-xl md:text-2xl font-light">
          Join the adventure and hunt for treasures in the crypto jungle!
        </p>
      </div>
      <!-- Token Information Section -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 mb-12">
        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Total Presale Tokens</p>
          <p class="text-3xl font-bold">150M $BIRDPAW</p>
        </div>
        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Price Per Token</p>
          <p class="text-3xl font-bold">0.001 ETH</p>
        </div>
        <div class="p-8 bg-gradient-to-tr from-blue-500 to-purple-600 rounded-lg shadow-lg text-center transform transition-all duration-300 hover:scale-110 hover:shadow-xl">
          <p class="text-xl font-semibold">Progress</p>
          <div class="w-full h-4 bg-gray-300 rounded-full mt-4">
            <div class="h-4 bg-green-500 rounded-full" style="width: 50%;"></div>
          </div>
          <p class="text-sm mt-2 text-gray-200">50% Sold</p>
        </div>
      </div>
      <!-- Call to Action -->
      <div class="text-center mt-8">
        <button class="bg-yellow-500 hover:bg-yellow-600 text-gray-900 font-bold py-3 px-8 rounded-lg transition duration-300 hover:shadow-xl">
          🐾 Grab Your $BIRDPAW Now!
        </button>
      </div>
    </div>
    """
  end
end
