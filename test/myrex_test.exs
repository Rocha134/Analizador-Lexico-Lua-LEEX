defmodule MyrexTest do
  use ExUnit.Case
  doctest Myrex

  test "greets the world" do
    assert Myrex.hello() == :world
  end
end
