defmodule BirdpawWeb.WhitepaperController do
  use BirdpawWeb, :controller

  def open_whitepaper(conn, %{"filename" => filename} = _params) do
    file_path = Application.app_dir(:spectra, "priv/static/docs/#{filename}")

    case File.read(file_path) do
      {:ok, data} ->
        conn
        |> put_resp_content_type("application/pdf")
        |> send_resp(200, data)

      {:error, _reason} ->
        send_resp(conn, 404, "File not found")
    end
  end
end
