defmodule Birdpaw.Utils.IPGeolocation do
  @moduledoc """
  This module fetches the country for a given IP address using a free API (ipinfo.io).
  """
  @api_url "http://ipinfo.io"

  def get_country_by_ip(ip_address) do
    url = "#{@api_url}/#{ip_address}/json"

    Finch.build(:get, url)
    |> Finch.request(Birdpaw.Finch)
    |> case do
      {:ok, %Finch.Response{body: body}} ->
        # Assuming the API returns JSON, you can parse the response.
        case Jason.decode(body) do
          {:ok, %{"country" => country}} ->
            {:ok, country}

          _ ->
            {:error, "Could not parse country"}
        end

      {:error, _reason} ->
        {:error, "Failed to get the country info"}
    end
  end
end
