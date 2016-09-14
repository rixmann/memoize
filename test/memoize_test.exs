defmodule MemoizeTest do
  use ExUnit.Case
  doctest Memoize

  test "the truth" do
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
  end

  defmodule TestModule do

    import Memoize

    defmemoize testfun(a, b), do: a + b

  end
end
