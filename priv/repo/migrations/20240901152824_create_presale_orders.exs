defmodule YourApp.Repo.Migrations.CreatePresaleOrders do
  use Ecto.Migration

  def change do
    create table(:presale_orders) do
      add :uuid, :string, null: false
      add :wallet_address, :string, null: false
      add :birdpaw_amount, :integer, null: false
      add :amount, :decimal, null: false
      add :timestamp, :utc_datetime, null: false
      add :payment_method, :string, null: false, default: "ETH"

      timestamps()
    end

    create unique_index(:presale_orders, [:uuid])
  end
end
