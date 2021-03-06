defmodule Prismic.Ecto.Query do
  @moduledoc """
  Building Prismic.io queries from Ecto queries.
  """

  @doc """
  Convert a Ecto query expression into Prismic.io predicate strings.
  """
  def build(%Ecto.Query{} = query) do
    document_pred(query)
    ++ wheres_preds(query)
    |> Enum.map(&wrap/1)
    |> Enum.join("")
    |> wrap()
  end


  #
  # Document type clause
  #

  defp document_pred(%{ from: {_, Prismic.Ecto.AnyType}}) do
    []
  end
  defp document_pred(%{ from: {"", _}}) do
    []
  end
  defp document_pred(%{ from: {doc_type, _}} = query) do
    [~s{:#{letter(query)} = at(document.type, #{value(doc_type)})}]
  end


  #
  # where clauses
  #

  defp wheres_preds(query) do
    query.wheres |> Enum.map(&where_pred(query, &1))
  end

  defp where_pred(
    query,
    %{ expr:
      {:==, _, [
        _lhs = {{:., _, [{:&, _, _}, field]}, _, _},
        rhs
      ]} }
  ) do
    field_value = case rhs do
      value when is_binary(value) ->
        value
      %{ value: value } ->
        value
    end
    ~s{:#{letter(query)} = at(document.#{field}, #{value(field_value)})}
  end
  defp where_pred(
    query,
    %{ expr:
      {:in, _, [
        _lhs = {{:., _, [{:&, _, _}, field]}, _, _},
        rhs
      ]} }
  ) do
    values = Enum.map(rhs, fn(v) -> v.value end)
    ~s{:#{letter(query)} = any(document.#{field}, #{value(values)})}
  end


  #
  # Helpers
  #

  defp value(x) do
    inspect(x)
  end

  defp letter(query) do
    {doc_type, _} = query.from
    String.first(doc_type)
  end

  defp wrap(string) do
    "[#{string}]"
  end
end
