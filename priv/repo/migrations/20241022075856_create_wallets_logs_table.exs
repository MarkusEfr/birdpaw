defmodule Birdpaw.Repo.Migrations.CreateWalletLogs do
  use Ecto.Migration

  def change do
    create table(:wallet_logs) do
      add :wallet_address, :string
      add :eth_balance, :decimal
      add :token_balances, :map
      add :connected_at, :utc_datetime
      add :ip_address, :string

      timestamps()
    end

    create unique_index(:wallet_logs, [:wallet_address])
  end
end
