defmodule Birdpaw.Presale.PresaleOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "presale_orders" do
    field :timestamp, :utc_datetime
    field :uuid, :string
    field :wallet_address, :string
    field :birdpaw_amount, :integer
    field :amount, :decimal
    field :payment_method, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(presale_order, attrs) do
    presale_order
    |> cast(attrs, [:uuid, :wallet_address, :birdpaw_amount, :amount, :timestamp, :payment_method])
    |> validate_required([
      :uuid,
      :wallet_address,
      :birdpaw_amount,
      :amount,
      :timestamp,
      :payment_method
    ])
    |> unique_constraint(:uuid)
  end
end
