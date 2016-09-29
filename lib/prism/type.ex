defmodule Prism.Type do
  @moduledoc """
  Prismic has document types, which have a JSON based schema. This module is
  used for introspection of these schemas.
  """

  defmodule Field do
    @moduledoc false
    defstruct type: nil, fields: %{}
  end

  @doc """
  Takes the JSON schema of a Prismic custom type and
  returns a list of fields from the type. This field may be
  nested.

  ## Return types

      {:ok, %{}}
      {:error, :invalid_json}
      {:error, :invalid_schema}
      {:error, :invalid_schema_field, field}
  """
  defdelegate schema_fields(schema), to: Prism.SchemaFields
end
