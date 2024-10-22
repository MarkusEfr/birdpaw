defmodule Birdpaw.WalletLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallet_logs" do
    field :wallet_address, :string
    field :eth_balance, :decimal
    field :token_balances, :map
    field :connected_at, :utc_datetime
    field :ip_address, :string

    timestamps()
  end

  @doc false
  def changeset(wallet_log, attrs) do
    wallet_log
    |> cast(attrs, [:wallet_address, :eth_balance, :token_balances, :connected_at, :ip_address])
    |> validate_required([:wallet_address, :eth_balance, :connected_at, :ip_address])
  end
end
