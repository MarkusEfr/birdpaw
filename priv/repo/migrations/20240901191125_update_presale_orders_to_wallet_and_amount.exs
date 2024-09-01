defmodule Birdpaw.Repo.Migrations.UpdatePresaleOrdersToWalletAndAmount do
  use Ecto.Migration

  def change do
    rename table(:presale_orders), :eth_address, to: :wallet_address
    rename table(:presale_orders), :eth_amount, to: :amount
  end
end
