defmodule TypeTest do
  use ExUnit.Case, async: true
  alias Prism.Type
  doctest Prism.Type

  describe "schema_fields/1" do
    test "invalid JSON errors" do
      schema = ~S"""
      {{}
      """
      data = Type.schema_fields(schema)
      assert {:error, :invalid_json} == data
    end

    test "schema with no Main property" do
      schema = ~S"""
      {
        "uid" : {
          "type" : "UID"
        }
      }
      """
      data = Type.schema_fields(schema)
      assert {:error, :invalid_schema} == data
    end

    test "schema with invalid Main property" do
      schema = ~S"""
      {
        "Main" : []
      }
      """
      data = Type.schema_fields(schema)
      assert {:error, :invalid_schema} == data
    end

    test "schema with invalid field" do
      schema = ~S"""
      {
        "Main" : {
          "size" : {
          }
        }
      }
      """
      data = Type.schema_fields(schema)
      assert {:error, :invalid_schema_field, _} = data
    end

    test "simple schema test" do
      schema = ~S"""
      {
        "Main" : {
          "uid" : {
            "type" : "UID",
            "fieldset" : "UID"
          },
          "title" : {
            "type" : "Text"
          }
        }
      }
      """
      assert {:ok, fields} = Type.schema_fields(schema)
      assert fields == %{
        "title" => %Type.Field{ type: "Text" },
        "uid" => %Type.Field{ type: "UID" },
      }
    end

    test "larger schema test" do
      schema = ~S"""
      {
        "Main" : {
          "uid" : {
            "type" : "UID",
            "fieldset" : "UID",
            "config" : {
              "placeholder" : "Leave blank to auto generate"
            }
          },
          "title" : {
            "type" : "Text",
            "config" : {
              "label" : "Job Position Title",
              "placeholder": "Frontend Engineer"
            }
          },
          "location" : {
            "type" : "Text",
            "config" : {
              "label" : "Location",
              "placeholder": "London, UK"
            }
          },
          "description" : {
            "type" : "Text",
            "config" : {
              "label" : "Short description"
            }
          },
          "jobURL" : {
            "type" : "Text",
            "config" : {
              "label" : "URL to more info",
              "placeholder": "https://www.example.com/job/"
            }
          }
        }
      }
      """
      assert {:ok, fields} = Type.schema_fields(schema)
      assert fields == %{
        "description" => %Type.Field{ type: "Text" },
        "jobURL" => %Type.Field{ type: "Text" },
        "location" => %Type.Field{ type: "Text" },
        "title" => %Type.Field{ type: "Text" },
        "uid" => %Type.Field{ type: "UID" },
      }
    end

    test "complex nested schema test" do
      schema = ~S"""
      {
        "Main" : {
          "uid" : {
            "type" : "UID",
            "fieldset" : "UID",
            "config" : {
              "placeholder" : "Leave blank to auto generate"
            }
          },
          "event" : {
            "type" : "Link",
            "fieldset" : "Featured Event",
            "config" : {
              "select" : "document",
              "customtypes" : [ "event" ],
              "placeholder" : "Link to a event"
            }
          },
          "events" : {
            "type" : "Group",
            "fieldset" : "Community Events",
            "config" : {
              "fields" : {
                "data" : {
                  "type" : "Link",
                  "config" : {
                    "select" : "document",
                    "customtypes" : [ "event" ],
                    "placeholder" : "Link to an event"
                  }
                },
                "level": {
                  "type" : "Select",
                  "config" : {
                    "label" : "Display Level",
                    "options" : [
                      "Featured",
                      "Highlighted"
                    ],
                    "placeholder" : "Regular"
                  }
                }
              }
            }
          }
        }
      }
      """
      assert {:ok, fields} = Type.schema_fields(schema)
      assert fields == %{
        "uid" => %Type.Field{ type: "UID" },
        "event" => %Type.Field{ type: "Link" },
        "events" => %Type.Field{
          type: "Group", fields: %{
            "data" => %Type.Field{ type: "Link" },
            "level" => %Type.Field{ type: "Select" },
          }
        },
      }
    end
  end
end
