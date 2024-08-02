defmodule BirdpawWeb.Components.Footer do
  @moduledoc """
  This module is used to render the Footer component.
  """
  use BirdpawWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <footer class="bg-gray-900 text-white py-10">
      <div class="max-w-6xl mx-auto px-4">
        <div class="flex flex-col md:flex-row justify-between items-center space-y-2 md:space-y-0">
          <div class="text-center md:text-left mb-4 md:mb-0">
            <p>© 2024 Birdcatcher Cats. All rights reserved.</p>
          </div>

          <div class="flex flex-wrap justify-center md:justify-start space-x-4 space-y-2 md:space-y-0">
            <a
              href="https://github.com/MarkusEfr/birdpaw"
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
              href="https://x.com/birdpaw_token"
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
              href="https://medium.com/@birdpaw"
              target="_blank"
              aria-label="Medium"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 1043.63 592.71"
              >
                <path d="M588.67 296.09c0 160.11-131.33 296.09-294.33 296.09C131.33 592.18 0 456.2 0 296.09 0 135.98 131.33 0 294.33 0c163 0 294.34 135.98 294.34 296.09Z" />
                <path d="M1043.63 296.09c0 157.66-58.62 286.99-131.07 286.99-72.45 0-131.07-127.22-131.07-284.88S840.12 4.32 912.57 4.32c72.45 0 131.06 133.77 131.06 291.77Z" />
                <path d="M729.13 296.09c0 147.83-29.49 267.62-65.88 267.62-36.4 0-65.88-119.79-65.88-267.62S626.86 28.47 663.25 28.47c36.39 0 65.88 119.78 65.88 267.62Z" />
              </svg>
              <span>Medium</span>
            </a>

            <a
              href="mailto:birdpaw@proton.me"
              aria-label="Email"
              class="flex items-center space-x-2 hover:text-gray-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 12.713L0 4.237V19c0 1.105.895 2 2 2h20c1.105 0 2-.895 2-2V4.237l-12 8.476zm12-10.15V3c0-1.105-.895-2-2-2H2C.895 1 0 1.895 0 3v.563l12 8.475 12-8.475z" />
              </svg>
              <span>birdpaw@proton.me</span>
            </a>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
