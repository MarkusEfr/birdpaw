defmodule Birdpaw.PresaleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Birdpaw.Presale` context.
  """

  @doc """
  Generate a unique presale_order uuid.
  """
  def unique_presale_order_uuid, do: "some uuid#{System.unique_integer([:positive])}"

  @doc """
  Generate a presale_order.
  """
  def presale_order_fixture(attrs \\ %{}) do
    {:ok, presale_order} =
      attrs
      |> Enum.into(%{
        birdpaw_amount: 42,
        eth_address: "some eth_address",
        eth_amount: "120.5",
        payment_method: "some payment_method",
        timestamp: ~U[2024-08-31 15:33:00Z],
        uuid: unique_presale_order_uuid()
      })
      |> Birdpaw.Presale.create_presale_order()

    presale_order
  end
end
