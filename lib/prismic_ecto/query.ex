defmodule PrismicEcto.Query do
  @moduledoc """
  Building Prismic.io queries from Ecto queries.
  """

  @doc """
  Convert a Ecto query expression into Prismic.io predicate strings.
  """
  def build(%Ecto.Query{} = query) do
    [document_pred(query) | wheres_preds(query)]
    |> Enum.map(&wrap/1)
    |> Enum.join("")
    |> wrap()
  end

  defp document_pred(query) do
    {doc_type, _schema_mod} = query.from
    ~s{:#{letter(query)} = at(document.type, #{value(doc_type)})}
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
        rhs = %{ value: _ }
      ]} }
  ) do
    ~s{:#{letter(query)} = at(document.#{field}, #{value(rhs.value)})}
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
