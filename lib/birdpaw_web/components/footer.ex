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
                <path d="M12 2C6.477 2 2 6.477 2 12c0 4.419 2.867 8.166 6.839 9.489.5.092.682-.217.682-.482 0-.237-.009-.868-.013-1.703-2.782.603-3.369-1.342-3.369-1.342-.454-1.156-1.11-1.464-1.11-1.464-.908-.62.069-.608.069-.608 1.004.07 1.532 1.032 1.532 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.087.636-1.337-2.22-.253-4.555-1.11-4.555-4.944 0-1.091.39-1.983 1.029-2.681-.103-.253-.446-1.272.098-2.65 0 0 .84-.269 2.75 1.025A9.56 9.56 0 0112 7.723c.85.004 1.705.115 2.504.337 1.909-1.294 2.748-1.025 2.748-1.025.545 1.378.202 2.397.1 2.65.641.698 1.028 1.59 1.028 2.681 0 3.842-2.338 4.687-4.566 4.937.36.31.68.92.68 1.855 0 1.338-.012 2.419-.012 2.748 0 .268.18.577.688.48C19.136 20.164 22 16.418 22 12c0-5.523-4.477-10-10-10z" />
              </svg>

              <span>GitHub</span>
            </a>

            <a
              href="https://x.com/birdcatchercats?t=jXadtsdB92jBjp95geU03g&s=09"
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
                <path d="M23.953 4.569c-.885.391-1.83.654-2.825.774 1.014-.611 1.794-1.574 2.163-2.723-.949.555-2.003.959-3.127 1.184-.897-.954-2.173-1.555-3.594-1.555-2.723 0-4.928 2.205-4.928 4.927 0 .39.044.765.128 1.124-4.094-.205-7.725-2.165-10.148-5.144-.425.725-.666 1.561-.666 2.457 0 1.695.86 3.188 2.175 4.065-.801-.026-1.554-.245-2.212-.612v.061c0 2.363 1.683 4.338 3.918 4.778-.41.112-.84.172-1.284.172-.313 0-.615-.03-.916-.086.617 1.924 2.4 3.292 4.515 3.332-1.656 1.297-3.745 2.067-6.013 2.067-.39 0-.776-.022-1.158-.068 2.138 1.372 4.674 2.171 7.403 2.171 8.862 0 13.707-7.34 13.707-13.707 0-.21-.005-.42-.014-.63.94-.681 1.761-1.532 2.407-2.504z" />
              </svg>

              <span>Twitter</span>
            </a>

            <a
              href="https://t.me/officialBirdcatcherCats"
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
                <path d="M21.505 2.74c.56.374.703.906.453 1.596l-3.26 12.285c-.21.832-.616 1.106-1.256.878l-5.52-3.885-2.598 2.504c-.171.168-.316.315-.646.315l.334-4.67 8.512-7.664c.375-.334-.084-.522-.58-.188l-10.53 6.623-4.524-1.414c-.928-.292-.948-.928.2-1.384l16.946-6.519c.416-.15.78-.145 1.126.097z" />
              </svg>

              <span>Telegram</span>
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
                <path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z" />
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
