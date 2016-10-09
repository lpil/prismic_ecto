defmodule Prismic.Ecto.Response do
  @moduledoc false

  fields = [:items, :count]
  @enforce_keys fields
  defstruct fields
end
