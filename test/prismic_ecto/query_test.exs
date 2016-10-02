defmodule Prismic.Ecto.QueryTest do
  use ExUnit.Case, async: true
  doctest Prismic.Ecto.Query
  import Ecto.Query

  defmacro query ~> expected_preds do
    quote bind_quoted: [query: query, expected_preds: expected_preds] do
      assert Prismic.Ecto.Query.build(query) == preds(expected_preds)
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

  test "from anything" do
    from("") ~> []
    from(Prismic.Ecto.AnyType) ~> []
  end

  test "where field ==" do
    Person
    |> where(id: 1337)
    ~> [
     ~s{:p = at(document.type, "person")},
     ~s{:p = at(document.id, 1337)},
   ]
  end

  test "where multiple fields ==" do
    Person
    |> where(name: "Tim")
    |> where(age: 50)
    ~> [
     ~s{:p = at(document.type, "person")},
     ~s{:p = at(document.name, "Tim")},
     ~s{:p = at(document.age, 50)},
   ]
  end

  test "where field in collection" do
    Person
    |> where([p], p.name in ["Tim", "Alice"])
    ~> [
     ~s{:p = at(document.type, "person")},
     ~s{:p = any(document.name, ["Tim", "Alice"])},
   ]
  end


  defp preds(ps) do
    wrap = &"[#{&1}]"
    ps |> Enum.map(wrap) |> Enum.join("") |> wrap.()
  end
end
