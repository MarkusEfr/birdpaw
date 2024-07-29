defmodule BirdpawWeb.Components.Attributes do
  @moduledoc """
  This module is used to render the attributes page.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mt-10">
      <div class="overlay w-full h-full flex flex-col items-center justify-center text-white p-4 md:p-8">
        <div class="bg-gray-800 bg-opacity-90 rounded-lg p-6 md:p-10 max-w-lg md:max-w-3xl text-center shadow-lg backdrop-filter backdrop-blur-sm border border-gray-700 animate-fadeInUp">
          <h1 class="title text-3xl md:text-5xl font-extrabold mb-2 md:mb-4 text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-500">
            Birdcatcher Cats (BIRDPAW)
          </h1>

          <h2 class="subtitle text-lg md:text-2xl font-semibold mb-4 md:mb-6 text-shadow-lg">
            Join the Hunt for Fun and Profit!
          </h2>

          <div class="token-parameters grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 md:mb-6">
            <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
              <img src="/images/attributes/1.png" alt="Name Icon" class="w-12 h-12" />
              <div class="text-start">
                <p class="font-bold text-lg">Name:</p>

                <p class="text-md">Birdcatcher Cats</p>
              </div>
            </div>

            <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
              <img src="/images/attributes/2.png" alt="Symbol Icon" class="w-12 h-12" />
              <div class="text-start">
                <p class="font-bold text-lg">Symbol:</p>

                <p class="text-md">$BIRDPAW</p>
              </div>
            </div>

            <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
              <img src="/images/attributes/3.png" alt="Total Supply Icon" class="w-12 h-12" />
              <div class="text-start">
                <p class="font-bold text-lg">Total Supply:</p>

                <p class="text-md">1,000,000,000 BIRDPAW</p>
              </div>
            </div>

            <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md">
              <img src="/images/attributes/4.png" alt="Network Icon" class="w-12 h-12" />
              <div class="text-start">
                <p class="font-bold text-lg">Network:</p>

                <p class="text-md">Ethereum (ERC-20)</p>
              </div>
            </div>

            <div class="flex items-center space-x-2 p-2 bg-gray-700 rounded-md col-span-1 md:col-span-2">
              <img
                src="/images/attributes/contract.webp"
                alt="Contract Address Icon"
                class="w-12 h-12"
              />
              <div class="text-start max-w-full overflow-hidden whitespace-nowrap text-ellipsis">
                <p class="font-bold text-lg">Contract Address:</p>

                <p id="contract-address" class="text-sm md:inline-block">
                  <%= @contract_address %>
                </p>
                <button
                  id="copy-button"
                  class="ml-2 bg-blue-500 text-white rounded-md px-2 py-1 text-sm"
                  phx-click="copy_address"
                  phx-value-address={@contract_address}
                >
                  Copy
                </button>
              </div>
            </div>
          </div>

          <button class="buy-button bg-orange-500 hover:bg-orange-600 text-white font-bold py-2 px-4 rounded-full text-lg md:text-2xl transition duration-300 ease-in-out transform hover:scale-105 mt-4">
            Buy $BIRDPAW
          </button>
        </div>
      </div>
    </div>
    """
  end
end
