#
# Adapt integration tests from here ->
# https://github.com/prismicio/javascript-kit/blob/master/test/test.js
#

defmodule IntegrationTest do
  use ExUnit.Case
  doctest Integration

  test "the truth" do
    assert 1 + 1 == 2
  end
end
