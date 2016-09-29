defmodule Prism.Type do
  @moduledoc """
  Prismic has document types, which have a JSON based schema. This module is
  used for introspection of these schemas.
  """

  defmodule Field do
    defstruct type: nil, fields: %{}
  end

  @doc """
  Takes the JSON schema of a Prismic custom type and
  returns a list of fields from the type. This field may be
  nested.

  ## Return types

      {:ok, [...]}
      {:error, :invalid_json}
      {:error, :invalid_schema}
      {:error, :invalid_schema_field, field}
  """
  def schema_fields(schema) when is_binary(schema) do
    with(
      {:ok, data} <- Poison.decode(schema),
      {:ok, data} <- Map.fetch(data, "Main"),
      {true, :map} <- {is_map(data), :map},
      {:ok, data} <- parse_fields(data)
    ) do
      {:ok, data}
    else
      {:error, _} ->
        {:error, :invalid_json}
      {:invalid_schema_field, field} ->
        {:error, :invalid_schema_field, field}
      _error ->
        {:error, :invalid_schema}
    end
  end

  defp parse_fields(fields, acc \\ %{})

  defp parse_fields(fields, acc) when is_map(fields) do
    fields |> Map.to_list |> parse_fields(acc)
  end

  defp parse_fields([], acc) do
    {:ok, acc}
  end

  defp parse_fields([{name, field_data}|rest], acc) do
    case parse_field(field_data) do
      {:ok, field} ->
        acc = Map.put(acc, name, field)
        parse_fields(rest, acc)
      error ->
        error
    end
  end

  defp parse_field(%{ "type" => "Group" } = field) do
    field
    |> get_in(["config", "fields"])
    |> parse_fields()
    |> case do
      {:ok, fields} ->
        {:ok, %Field{ type: "Group", fields: fields }}
      error ->
        error
    end
  end

  defp parse_field(%{ "type" => type }) do
    {:ok, %Field{ type: type }}
  end

  defp parse_field(field) do
    {:invalid_schema_field, field}
  end
end
