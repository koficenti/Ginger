defmodule GingerTest do
  use ExUnit.Case
  doctest Ginger

  test "running" do
    Ginger.start(nil, nil)
    assert true
  end
end
