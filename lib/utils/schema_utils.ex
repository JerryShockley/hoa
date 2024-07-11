defmodule Utils.SchemaUtils do
  @moduledoc """
  Used by application schema files to provide a common
  set of methods to provide access to db field names.
  This module requires the schema files using this module
  to declare two module attributes (@required and @optional)
  prior to adding the call for this module. The @required
  attribute contains a list of the db field names that are
  required and the @optional attribute contains the remaining
  db field names such that there are no common elements in
  the two lists.

  *** Example usage in a file containing a schema

    @required ~w(first_name last_name mobile)a
    @optional ~w(dob work_phone)a
    use Utils.SchemaUtils

  """
  defmacro __using__(_) do
    quote do
      def fields(:all), do: @required_fields ++ @optional_fields
      def fields(:required), do: @required_fields
      def fields(:optional), do: @optional_fields
      def fields(_), do: []
    end
  end
end
