defmodule Utils.CustomValidations do
  use Ecto.Schema
  import Ecto.Changeset

  def validate_date_in_range(changeset, field, start_date, end_date) when is_atom(field) do
    validate_change(changeset, field, fn field, value ->
      case Date.compare(value, start_date) == :gt and Date.compare(value, end_date) == :lt do
        true ->
          []

        false ->
          [{field, "Date is out of range"}]
      end
    end)
  end
end
