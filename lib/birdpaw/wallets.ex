defmodule Birdpaw.Wallets do
  alias Birdpaw.Repo
  alias Birdpaw.WalletLog
  alias Birdpaw.PresaleOrder
  import Ecto.Query, only: [from: 2]

  @doc """
  Fetches the wallet logs based on optional filters like date range, wallet address, or ETH balance.

  ## Parameters
  - `params`: A map of optional filters.
    - `:start_date` - (optional) start date for filtering logs.
    - `:end_date` - (optional) end date for filtering logs.
    - `:eth_min` - (optional) minimum ETH balance filter.
    - `:eth_max` - (optional) maximum ETH balance filter.

  ## Returns
  A list of wallet logs matching the criteria.
  """
  def fetch_wallet_logs(params \\ %{}) do
    query =
      from wl in WalletLog,
        # Check if a presale order exists for the wallet address
        select: %{
          wallet_address: wl.wallet_address,
          eth_balance: wl.eth_balance,
          connected_at: wl.connected_at,
          ip_address: wl.ip_address,
          token_balances: wl.token_balances,
          placed_order:
            fragment(
              "EXISTS (SELECT 1 FROM presale_orders po WHERE po.wallet_address = ?)",
              wl.wallet_address
            )
        },
        order_by: [desc: wl.connected_at]

    # Apply date range filtering
    query =
      if params[:date_from] && params[:date_to] do
        start_datetime = DateTime.new!(params[:date_from], ~T[00:00:00], "Etc/UTC")
        end_datetime = DateTime.new!(params[:date_to], ~T[23:59:59], "Etc/UTC")

        from wl in query,
          where: wl.connected_at >= ^start_datetime and wl.connected_at <= ^end_datetime
      else
        query
      end

    # Apply ETH balance minimum filtering if provided
    query =
      if params[:eth_min] do
        from wl in query, where: wl.eth_balance >= ^params[:eth_min]
      else
        query
      end

    # Apply ETH balance maximum filtering if provided
    query =
      if params[:eth_max] do
        from wl in query, where: wl.eth_balance <= ^params[:eth_max]
      else
        query
      end

    # Execute the query with filters applied
    Repo.all(query)
  end

  # Log a wallet connection
  def log_wallet_connection(
        %{
          "wallet_address" => wallet_address,
          "eth_balance" => eth_balance,
          "tokens" => tokens
        },
        ip_address \\ "N/A"
      ) do
    if Repo.get_by(WalletLog, wallet_address: wallet_address) == nil do
      token_balances =
        Enum.reduce(tokens, %{}, fn token, acc ->
          Map.put(acc, token["symbol"], %{
            balance: token["balance"],
            raw_balance: token["rawBalance"],
            token_address: token["tokenAddress"]
          })
        end)

      %WalletLog{}
      |> WalletLog.changeset(%{
        wallet_address: wallet_address,
        eth_balance: Decimal.new(eth_balance),
        token_balances: token_balances,
        connected_at: DateTime.utc_now() |> DateTime.truncate(:second),
        ip_address: ip_address
      })
      |> Repo.insert()
    end
  end
end
