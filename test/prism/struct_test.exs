defmodule Prism.StructTest do
  use ExUnit.Case, async: true
  doctest Prism.Struct
  alias Prism.Type.Field

  describe "fields_to_attrs/1" do
    test "no fields" do
      fields = %{}
      attrs = Prism.Struct.fields_to_attrs(fields)
      assert attrs == []
    end

    test "flat fields" do
      fields = %{
        "uid" => %Field{ type: "UID" },
        "event" => %Field{ type: "Link" },
      }
      attrs = Prism.Struct.fields_to_attrs(fields)
      assert attrs == [
        {nil, [:event, :uid]},
      ]
    end

    test "nested fields" do
      fields = %{
        "uid" => %Field{ type: "UID" },
        "event" => %Field{ type: "Link" },
        "events" => %Field{
          type: "Group", fields: %{
            "data" => %Field{ type: "Link" },
            "level" => %Field{ type: "Select" },
          }
        },
      }
      attrs = Prism.Struct.fields_to_attrs(fields)
      assert attrs == [
        {nil, [:event, :events, :uid]},
        {Events, [:data, :level]},
      ]
    end
  end
end
