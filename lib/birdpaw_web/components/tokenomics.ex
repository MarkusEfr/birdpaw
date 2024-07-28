defmodule BirdpawWeb.Components.Tokenomics do
  @moduledoc """
  This module is used to render the Tokenomics page.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="tokenomics-section bg-gray-900 text-white py-12">
      <h2 class="text-3xl md:text-4xl text-center mb-8 font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-500">
        Tokenomics
      </h2>
      <p class="text-center text-lg md:text-xl mb-10 px-4 md:px-8">
        Understanding the distribution, allocation, and rewards of our tokens is crucial for our community. Here's a detailed look at how our tokens are managed to ensure a balanced and prosperous ecosystem.
      </p>
      <div class="flex flex-wrap justify-center items-center gap-10 max-w-6xl mx-auto">
        <div class="flex flex-col items-center bg-gray-800 p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 w-64">
          <div class="relative w-32 h-32 mb-4">
            <svg class="w-full h-full">
              <circle cx="50%" cy="50%" r="45%" stroke="#4A5568" stroke-width="10%" fill="none" />
              <circle
                cx="50%"
                cy="50%"
                r="45%"
                stroke="#4299E1"
                stroke-width="10%"
                fill="none"
                stroke-dasharray="282.6"
                stroke-dashoffset="113.04"
                stroke-linecap="round"
              />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-xl font-semibold">60%</span>
            </div>
          </div>
          <h3 class="text-xl font-semibold mt-4 text-green-400">Distribution</h3>
          <p class="text-center text-md mt-2">
            Our tokens are distributed among various stakeholders to ensure a balanced and fair ecosystem.
          </p>
        </div>
        <div class="flex flex-col items-center bg-gray-800 p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 w-64">
          <div class="relative w-32 h-32 mb-4">
            <svg class="w-full h-full">
              <circle cx="50%" cy="50%" r="45%" stroke="#4A5568" stroke-width="10%" fill="none" />
              <circle
                cx="50%"
                cy="50%"
                r="45%"
                stroke="#48BB78"
                stroke-width="10%"
                fill="none"
                stroke-dasharray="282.6"
                stroke-dashoffset="197.82"
                stroke-linecap="round"
              />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-xl font-semibold">30%</span>
            </div>
          </div>
          <h3 class="text-xl font-semibold mt-4 text-blue-400">Allocation</h3>
          <p class="text-center text-md mt-2">
            Token allocation for different purposes, including development, marketing, and partnerships.
          </p>
        </div>
        <div class="flex flex-col items-center bg-gray-800 p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 w-64">
          <div class="relative w-32 h-32 mb-4">
            <svg class="w-full h-full">
              <circle cx="50%" cy="50%" r="45%" stroke="#4A5568" stroke-width="10%" fill="none" />
              <circle
                cx="50%"
                cy="50%"
                r="45%"
                stroke="#9F7AEA"
                stroke-width="10%"
                fill="none"
                stroke-dasharray="282.6"
                stroke-dashoffset="254.34"
                stroke-linecap="round"
              />
            </svg>
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="text-xl font-semibold">10%</span>
            </div>
          </div>
          <h3 class="text-xl font-semibold mt-4 text-purple-400">Rewards</h3>
          <p class="text-center text-md mt-2">
            Rewards for our loyal community members and contributors, ensuring long-term engagement and growth.
          </p>
        </div>
      </div>
    </div>
    """
  end
end
