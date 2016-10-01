defmodule Prism.Type do
  @moduledoc """
  Prismic has document types, which have a JSON based schema. This module is
  used for introspection of these schemas.
  """

  defmodule Field do
    @moduledoc false
    @enforce_keys [:type]
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

  @doc """
  Define a Prismic type, creating structs and functions for iteracting with
  the Prismic API.

  This macro takes the following options

  - `name:` The name given to the document type in Prismic.
  - `schema:` The document JSON schema in Prismic.

  When used like so:

      defmodule PersonType do
        use Prism.Type,
          name: "Person",
          schema: \"\"\"
          {
            "Main" : {
              "uid"  : { "type" : "UID" },
              "name" : { "type" : "Text" }
            }
          }
          \"\"\"
      end

  The following struct would be defined:

      %PersonType{ uid: nil, name: nil }
  """
  defmacro __using__(opts) do
    top_mod = hd(__CALLER__.context_modules)
    quote bind_quoted: [top_mod: top_mod, opts: opts] do
      with(
        {:ok, schema} <- Dict.fetch(opts, :schema),
        {:ok, fields} <- Prism.Type.schema_fields(schema),
        attrs <- Prism.Struct.fields_to_attrs(fields)
      ) do
        Enum.map(attrs, fn
          ({nil, attrs}) -> defstruct attrs
          ({mod, attrs}) ->
            defmodule Module.concat(top_mod, mod) do
              @moduledoc false
              defstruct attrs
            end
        end)
      else
        {:error, error} ->
          raise(ArgumentError, error)
      end
    end
  end
end
