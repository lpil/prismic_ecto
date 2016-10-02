defmodule Prismic.Ecto.WriteError do
  @moduledoc """
  A write has been attempted against the Prismic.io API via the Prismic.Ecto
  library. Prismic.io is read only, so this is not possible.
  """

  defexception []

  def message(_), do: @moduledoc
end
