defmodule BirdpawWeb.Components.Footer do
  @moduledoc """
  This module is used to render the Footer component.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="bg-gray-900 text-white py-8">
      <div class="max-w-6xl mx-auto px-4">
        <div class="flex flex-col md:flex-row justify-between items-center">
          <div class="text-center md:text-left mb-4 md:mb-0">
            <h3 class="text-xl font-semibold">Birdcatcher Cats</h3>
            <p>© 2024 Birdcatcher Cats. All rights reserved.</p>
          </div>
          <div class="flex space-x-6">
            <a
              href="https://github.com"
              target="_blank"
              aria-label="GitHub"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.728-4.042-1.61-4.042-1.61-.546-1.386-1.332-1.757-1.332-1.757-1.089-.745.083-.729.083-.729 1.205.084 1.838 1.237 1.838 1.237 1.07 1.834 2.807 1.304 3.492.997.108-.775.42-1.304.763-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.31.467-2.382 1.235-3.221-.123-.303-.536-1.523.117-3.176 0 0 1.008-.322 3.3 1.23.957-.266 1.98-.399 3-.404 1.02.005 2.043.138 3 .404 2.29-1.553 3.296-1.23 3.296-1.23.653 1.653.241 2.873.118 3.176.77.839 1.233 1.911 1.233 3.221 0 4.609-2.805 5.623-5.476 5.921.43.372.815 1.102.815 2.222 0 1.604-.015 2.896-.015 3.286 0 .322.215.694.825.576 4.765-1.584 8.2-6.082 8.2-11.384 0-6.627-5.373-12-12-12z" />
              </svg>
              <span>GitHub</span>
            </a>
            <a
              href="https://twitter.com"
              target="_blank"
              aria-label="Twitter"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.611 1.798-1.574 2.165-2.723-.951.555-2.005.959-3.127 1.184-.896-.954-2.173-1.55-3.591-1.55-2.717 0-4.92 2.203-4.92 4.917 0 .39.045.765.128 1.124-4.083-.205-7.699-2.158-10.126-5.127-.422.725-.666 1.561-.666 2.457 0 1.694.863 3.188 2.175 4.065-.8-.025-1.554-.245-2.212-.612v.061c0 2.366 1.683 4.342 3.918 4.785-.41.111-.84.171-1.284.171-.314 0-.618-.031-.917-.089.631 1.953 2.445 3.376 4.6 3.417-1.684 1.319-3.808 2.107-6.114 2.107-.397 0-.787-.023-1.175-.069 2.179 1.397 4.768 2.211 7.557 2.211 9.054 0 14-7.496 14-13.986 0-.213-.005-.426-.014-.637.962-.695 1.8-1.562 2.463-2.549z" />
              </svg>
              <span>Twitter</span>
            </a>
            <a
              href="https://t.me"
              target="_blank"
              aria-label="Telegram"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 0c-6.627 0-12 5.373-12 12 0 6.627 5.373 12 12 12 6.627 0 12-5.373 12-12 0-6.627-5.373-12-12-12zm5.64 8.362l-1.528 7.142c-.114.492-.416.61-.844.381l-2.34-1.753-1.128 1.084c-.156.156-.289.289-.593.289l.21-2.982 5.419-4.898c.234-.208-.053-.326-.361-.118l-6.7 4.217-2.884-.9c-.626-.195-.638-.626.13-.926l11.226-4.32c.52-.195.975.118.81.908z" />
              </svg>
              <span>Telegram</span>
            </a>
            <a
              href={~p"/docs/whitepaper.pdf"}
              target="_blank"
              aria-label="Whitepaper"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12S18.627 0 12 0zm-1 18H9v-2h2v2zm1.36-4.36c-.8.37-1.2.9-1.2 1.55h-2c0-.85.38-1.54 1.14-2.05.55-.37.85-.73.85-1.18 0-.38-.25-.69-.64-.69-.48 0-.76.31-.76.74h-2c0-1.59 1.2-2.5 2.78-2.5 1.44 0 2.5.88 2.5 2.09 0 .88-.47 1.41-1.22 1.86z" />
              </svg>
              <span>Whitepaper</span>
            </a>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
