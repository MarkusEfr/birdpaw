defmodule BirdpawWeb.Components.Roadmap do
  @moduledoc """
  This module is used to render the Roadmap page.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="roadmap-section py-16 bg-fixed"
      style="background-image: url('/images/roadmap-bg.webp');"
    >
      <div class="max-w-6xl mx-auto relative px-4" phx-hook="ScrollReveal" id="timeline">
        <div class="timeline-line absolute left-1/2 transform -translate-x-1/2 bg-gradient-to-b from-gray-600 to-gray-800 w-1 h-full">
        </div>

        <div class="timeline-item relative flex flex-col items-center mb-16 opacity-0">
          <div class="timeline-icon bg-blue-600 text-white rounded-full p-4 mb-4 shadow-lg flex items-center justify-center text-2xl font-bold">
            1
          </div>
          <div class="timeline-content bg-gray-800 p-8 rounded-lg shadow-lg text-center w-full md:w-3/4 lg:w-2/3">
            <h3 class="text-3xl font-semibold mb-2 text-white">Project Launch</h3>
            <p class="text-lg text-blue-400 mb-4">Phase 1 (Done)</p>
            <p class="text-md text-gray-300">
              <span class="font-bold text-yellow-300">Official Launch:</span>
              The Birdcatcher Cats (BIRDPAW) project officially launched with successful token distribution and initial marketing campaigns. The community has been engaged and early supporters onboarded.
            </p>
          </div>
        </div>

        <div class="timeline-item relative flex flex-col items-center mb-16 opacity-0">
          <div class="timeline-icon bg-green-600 text-white rounded-full p-4 mb-4 shadow-lg flex items-center justify-center text-2xl font-bold">
            2
          </div>
          <div class="timeline-content bg-gray-800 p-8 rounded-lg shadow-lg text-center w-full md:w-3/4 lg:w-2/3">
            <h3 class="text-3xl font-semibold mb-2 text-white">Platform Development</h3>
            <p class="text-lg text-green-400 mb-4">Phase 2 (In Progress)</p>
            <p class="text-md text-gray-300">
              <span class="font-bold text-yellow-300">Building the Future:</span>
              We are currently developing the BIRDPAW platform. This includes integrating a user-friendly wallet, enhancing UI/UX design, and creating robust backend support. Stay tuned for exciting features!
            </p>
          </div>
        </div>

        <div class="timeline-item relative flex flex-col items-center mb-16 opacity-0">
          <div class="timeline-icon bg-purple-600 text-white rounded-full p-4 mb-4 shadow-lg flex items-center justify-center text-2xl font-bold">
            3
          </div>
          <div class="timeline-content bg-gray-800 p-8 rounded-lg shadow-lg text-center w-full md:w-3/4 lg:w-2/3">
            <h3 class="text-3xl font-semibold mb-2 text-white">Exchange Listings</h3>
            <p class="text-lg text-purple-400 mb-4">Phase 3 (Upcoming)</p>
            <p class="text-md text-gray-300">
              <span class="font-bold text-yellow-300">Gaining Traction:</span>
              Our goal is to list BIRDPAW on major cryptocurrency exchanges to boost liquidity and accessibility. We're in talks with multiple exchanges and preparing for a significant expansion.
            </p>
          </div>
        </div>

        <div class="timeline-item relative flex flex-col items-center mb-16 opacity-0">
          <div class="timeline-icon bg-orange-600 text-white rounded-full p-4 mb-4 shadow-lg flex items-center justify-center text-2xl font-bold">
            4
          </div>
          <div class="timeline-content bg-gray-800 p-8 rounded-lg shadow-lg text-center w-full md:w-3/4 lg:w-2/3">
            <h3 class="text-3xl font-semibold mb-2 text-white">NFT Marketplace Launch</h3>
            <p class="text-lg text-orange-400 mb-4">Phase 4 (Upcoming)</p>
            <p class="text-md text-gray-300">
              <span class="font-bold text-yellow-300">Explore & Trade:</span>
              Launching an exclusive NFT marketplace for BIRDPAW-themed assets. Users will be able to create, trade, and collect unique NFTs. We're collaborating with artists to bring you one-of-a-kind digital collectibles.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
