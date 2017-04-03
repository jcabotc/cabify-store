defmodule Scanner.ParserTest do
  use ExUnit.Case, async: true

  alias Scanner.Parser

  @correspondence %{"FOO" => :foo,
                    "BAR" => :bar}

  test "parse/2" do
    assert {:ok, :foo} == Parser.parse("FOO", @correspondence)
    assert {:ok, :bar} == Parser.parse("BAR", @correspondence)

    expected_reason = {:unknown_code, "BAZ"}
    assert {:error, expected_reason} == Parser.parse("BAZ", @correspondence)
  end
end
