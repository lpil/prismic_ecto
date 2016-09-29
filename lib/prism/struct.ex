defmodule Prism.Struct do
  @moduledoc false

  @doc """
  Takes a list of type schema fields and returns the fields that would be
  needed to represent the schema with structs.

      iex> Prism.Struct.fields_to_attrs(%{
      ...>   "uid" => %Prism.Type.Field{ type: "UID" },
      ...>   "event" => %Prism.Type.Field{ type: "Link" },
      ...> })
      [{nil, [:event, :uid]}]
  """
  def fields_to_attrs(fields) do
    fields_to_attrs(fields, nil)
  end

  defp fields_to_attrs(fields, level) when is_map(fields) do
    fields |> Enum.to_list |> fields_to_attrs(level)
  end
  defp fields_to_attrs([], _level) do
    []
  end
  defp fields_to_attrs(fields, level) do
    nested_fields =
      fields
      |> Enum.filter(&child_fields?/1)
      |> Enum.flat_map(&child_field_to_attrs(&1, level))
    attrs =
      Enum.map(fields, &atom_name/1)
    [{level, attrs} | nested_fields]
  end

  defp child_fields?({_name, field}) do
    Map.size(field.fields) > 0
  end

  defp atom_name({name, _field}) do
    name |> String.downcase |> String.to_atom
  end
  defp mod_name(name) do
    name |> String.capitalize |> String.to_atom
  end

  defp child_field_to_attrs({name, field}, parent) do
    mod =
      [parent, mod_name(name)]
      |> Enum.reject(&(&1 == nil))
      |> Module.concat
    fields_to_attrs(field.fields, mod)
  end
end
