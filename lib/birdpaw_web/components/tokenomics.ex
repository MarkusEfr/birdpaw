defmodule BirdpawWeb.Components.Tokenomics do
  @moduledoc """
  This module is used to render the Tokenomics page.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="tokenomics-section bg-gray-900 text-white py-8 md:py-16">
      <h2 class="text-center mb-8 md:mb-12 text-xl md:text-3xl">Tokenomics</h2>
      
      <div class="flex flex-col max-w-6xl mx-auto space-y-8 md:space-y-12 px-4 md:px-0">
        <div class="flex flex-col md:flex-row items-center bg-gray-800 rounded-lg p-4 md:p-6 shadow-lg">
          <img
            src="/images/tokenomics/distribution.png"
            alt="Distribution Icon"
            class="w-12 h-12 md:w-16 md:h-16 mb-4 md:mb-0 md:mr-6"
          />
          <div class="flex-1 text-center md:text-left">
            <h3 class="text-2xl md:text-3xl font-semibold mb-2 text-blue-300">Distribution</h3>
            
            <p class="text-sm md:text-lg mb-4">
              Tokens are distributed among various stakeholders to ensure balanced growth and project stability.
            </p>
            
            <div class="relative w-full bg-gray-700 rounded-full h-6 md:h-8 overflow-hidden">
              <div
                class="absolute top-0 left-0 h-full bg-blue-500 text-center text-white text-xs md:text-sm font-bold leading-6 md:leading-8"
                style="width: 50%"
              >
                <span class="absolute inset-0 flex items-center justify-center">50%</span>
              </div>
            </div>
          </div>
        </div>
        
        <div class="flex flex-col md:flex-row items-center bg-gray-800 rounded-lg p-4 md:p-6 shadow-lg">
          <img
            src="/images/tokenomics/allocation.png"
            alt="Allocation Icon"
            class="w-12 h-12 md:w-16 md:h-16 mb-4 md:mb-0 md:mr-6"
          />
          <div class="flex-1 text-center md:text-left">
            <h3 class="text-2xl md:text-3xl font-semibold mb-2 text-green-300">Allocation</h3>
            
            <p class="text-sm md:text-lg mb-4">
              Token allocation for development, marketing, and future initiatives to ensure continued project growth.
            </p>
            
            <div class="relative w-full bg-gray-700 rounded-full h-6 md:h-8 overflow-hidden">
              <div
                class="absolute top-0 left-0 h-full bg-green-500 text-center text-white text-xs md:text-sm font-bold leading-6 md:leading-8"
                style="width: 35%"
              >
                <span class="absolute inset-0 flex items-center justify-center">35%</span>
              </div>
            </div>
          </div>
        </div>
        
        <div class="flex flex-col md:flex-row items-center bg-gray-800 rounded-lg p-4 md:p-6 shadow-lg">
          <img
            src="/images/tokenomics/rewards.png"
            alt="Rewards Icon"
            class="w-12 h-12 md:w-16 md:h-16 mb-4 md:mb-0 md:mr-6"
          />
          <div class="flex-1 text-center md:text-left">
            <h3 class="text-2xl md:text-3xl font-semibold mb-2 text-purple-300">Rewards</h3>
            
            <p class="text-sm md:text-lg mb-4">
              Rewards allocated to participants and token holders to incentivize engagement and long-term commitment.
            </p>
            
            <div class="relative w-full bg-gray-700 rounded-full h-6 md:h-8 overflow-hidden">
              <div
                class="absolute top-0 left-0 h-full bg-purple-500 text-center text-white text-xs md:text-sm font-bold leading-6 md:leading-8"
                style="width: 15%"
              >
                <span class="absolute inset-0 flex items-center justify-center">15%</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
