defmodule Prismic.Ecto.AnyType do
  @moduledoc """
  An Ecto schema for querying any Prismic.io document type.

      query = from x in Prismic.Ecto.AnyType,
            select: x
      Repo.all(query)
  """
  use Ecto.Schema

  schema "any" do
  end
end
