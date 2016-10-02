defmodule PrismicEcto.QueryTest do
  use ExUnit.Case, async: true
  doctest PrismicEcto.Query
  import Ecto.Query

  defmacro query ~> expected_preds do
    quote bind_quoted: [query: query, expected_preds: expected_preds] do
      assert PrismicEcto.Query.build(query) == preds(expected_preds)
    end
  end

  defmodule Person do
    use Ecto.Schema

    schema "person" do
      field :name, :string
      field :age, :integer
    end
  end


  test "from schema" do
    Person
    |> from()
    ~> [
      ~s{:p = at(document.type, "person")}
    ]
  end

  test "from string" do
    "cat"
    |> from()
    ~> [
      ~s{:c = at(document.type, "cat")}
    ]
  end

  test "select id" do
    Person
    |> where(id: 1337)
    ~> [
     ~s{:p = at(document.type, "person")},
     ~s{:p = at(document.id, 1337)},
   ]
  end



  defp preds(ps) do
    wrap = &"[#{&1}]"
    wrap.(ps |> Enum.map(wrap) |> Enum.join(""))
  end
end
