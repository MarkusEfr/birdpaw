defmodule Birdpaw.Repo.Migrations.AddOrderStateToPresaleOrders do
  use Ecto.Migration

  def change do
    alter table(:presale_orders) do
      add :order_state, :string, default: "pending", null: false
    end
  end
end
