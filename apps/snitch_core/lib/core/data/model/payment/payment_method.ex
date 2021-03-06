defmodule Snitch.Data.Model.PaymentMethod do
  @moduledoc """
  PaymentMethod API and utilities.

  Snitch currently supports the following payment methods:

  ## Debit and Credit cards

  See `Snitch.Data.Model.CardPayment`. Such payments are backed by the
  "`snitch_card_payments`" table that references the `Card` used for payment.

  ## Check or Cash (and cash-on-delivery)

  There's no separate schema for such payments as they are completely expressed
  by the fields in `Snitch.Data.Model.Payment`.
  """
  use Snitch.Data.Model

  alias Snitch.Data.Schema.PaymentMethod

  @spec create(String.t(), String.t(), boolean()) ::
          {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()}
  def create(name, code, is_active? \\ true) do
    params = %{name: name, code: code, active?: is_active?}
    QH.create(PaymentMethod, params, Repo)
  end

  @spec update(map, PaymentMethod.t() | nil) ::
          {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()}
  def update(query_fields, instance \\ nil) do
    QH.update(PaymentMethod, query_fields, instance, Repo)
  end

  @doc """
  Deletes a PaymentMethod.
  """
  @spec delete(non_neg_integer | PaymentMethod.t()) ::
          {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()} | {:error, :not_found}
  def delete(id_or_instance) do
    QH.delete(PaymentMethod, id_or_instance, Repo)
  end

  @spec get(map | non_neg_integer) :: PaymentMethod.t() | nil
  def get(query_fields_or_primary_key) do
    QH.get(PaymentMethod, query_fields_or_primary_key, Repo)
  end

  @spec get_card() :: PaymentMethod.t() | nil
  def get_card do
    get(%{code: "ccd"})
  end

  @spec get_check() :: PaymentMethod.t() | nil
  def get_check do
    get(%{code: "chk"})
  end

  @spec get_all() :: [PaymentMethod.t()]
  def get_all, do: Repo.all(PaymentMethod)
end
