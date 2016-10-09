#
# Adapt integration tests from here ->
# https://github.com/prismicio/javascript-kit/blob/master/test/test.js
#

defmodule IntegrationTest do
  use ExUnit.Case, async: false
  doctest Integration

  import Ecto.Query
  alias Integration.{Repo, Contributor}

  test "the truth" do
    Contributor
    |> where(id: "UrkL8wEAAOFjpbUT")
    |> Repo.all
    |> IO.inspect
  end
end
