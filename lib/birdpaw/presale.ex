defmodule Birdpaw.Presale do
  @moduledoc """
  The Presale context.
  """

  import Ecto.Query, warn: false
  alias Birdpaw.Repo
  alias Birdpaw.PresaleOrder

  @doc """
  Returns the list of presale_orders.

  ## Examples

      iex> list_presale_orders()
      [%PresaleOrder{}, ...]

  """
  def list_presale_orders do
    Repo.all(PresaleOrder)
  end

  @doc """
  Returns a list of orders for a specific wallet address.

  ## Examples

      iex> get_orders_by_wallet_address("0x123...")
      [%PresaleOrder{}, ...]

  """
  def get_orders_by_wallet_address(wallet_address) do
    query = from o in PresaleOrder, where: o.wallet_address == ^wallet_address
    Repo.all(query)
  end

  @doc """
  Gets a single presale_order.

  Raises `Ecto.NoResultsError` if the Presale order does not exist.

  ## Examples

      iex> get_presale_order!(123)
      %PresaleOrder{}

      iex> get_presale_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_presale_order!(id), do: Repo.get!(PresaleOrder, id)

  @doc """
  Creates a presale_order.

  ## Examples

      iex> create_presale_order(%{field: value})
      {:ok, %PresaleOrder{}}

      iex> create_presale_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_presale_order(attrs \\ %{}) do
    %PresaleOrder{}
    |> PresaleOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a presale_order.

  ## Examples

      iex> update_presale_order(presale_order, %{field: new_value})
      {:ok, %PresaleOrder{}}

      iex> update_presale_order(presale_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_presale_order(%PresaleOrder{} = presale_order, attrs) do
    presale_order
    |> PresaleOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a presale_order.

  ## Examples

      iex> delete_presale_order(presale_order)
      {:ok, %PresaleOrder{}}

      iex> delete_presale_order(presale_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_presale_order(%PresaleOrder{} = presale_order) do
    Repo.delete(presale_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking presale_order changes.

  ## Examples

      iex> change_presale_order(presale_order)
      %Ecto.Changeset{data: %PresaleOrder{}}

  """
  def change_presale_order(%PresaleOrder{} = presale_order, attrs \\ %{}) do
    PresaleOrder.changeset(presale_order, attrs)
  end
end
