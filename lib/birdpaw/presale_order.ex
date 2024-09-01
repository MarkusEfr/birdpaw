defmodule Birdpaw.PresaleOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "presale_orders" do
    field :wallet_address, :string
    field :birdpaw_amount, :integer
    field :amount, :float
    field :order_state, :string, default: "pending"
    field :uuid, :string
    field :timestamp, :utc_datetime
    field :payment_method, :string

    timestamps()
  end

  @doc false
  def changeset(presale_order, attrs) do
    presale_order
    |> cast(attrs, [
      :wallet_address,
      :birdpaw_amount,
      :amount,
      :order_state,
      :uuid,
      :timestamp,
      :payment_method
    ])
    |> validate_required([
      :wallet_address,
      :birdpaw_amount,
      :amount,
      :order_state,
      :uuid,
      :timestamp,
      :payment_method
    ])
  end
end
