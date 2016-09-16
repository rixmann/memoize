defmodule MemoizeTest do
  use ExUnit.Case
  doctest Memoize

  setup do
    Memoize.invalidate(nil, nil, nil)
    []
  end

  test "cache-hit" do
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
  end

  test "count" do
    assert Memoize.Cache.count == 0
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert Memoize.Cache.count == 1
    assert MemoizeTest.TestModule.testfun(1, 2) == 3
    assert Memoize.Cache.count == 2
    assert MemoizeTest.TestModule.testfun(2, 2) == 4
    assert Memoize.Cache.count == 3
    assert MemoizeTest.TestModule.testfun2(1, 1) == 1
    assert Memoize.Cache.count == 4
    assert MemoizeTest.TestModule2.testfun(2, 2) == 4
    assert Memoize.Cache.count == 5
  end

  test "invalidate" do

    ## test invalidate all
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert MemoizeTest.TestModule.testfun(1, 2) == 3
    assert Memoize.Cache.count == 2
    assert Memoize.invalidate(nil, nil, nil) == true
    assert Memoize.Cache.count == 0

    ## test invalidate by function name
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert MemoizeTest.TestModule.testfun2(1, 1) == 1
    assert Memoize.Cache.count == 2
    assert Memoize.invalidate(nil, :testfun2, nil) == true
    assert Memoize.Cache.count == 1

    ## test invalidate by params
    assert MemoizeTest.TestModule.testfun2(1, 1) == 1
    assert Memoize.Cache.count == 2
    assert Memoize.invalidate(nil, nil, [1, 1]) == true
    assert Memoize.Cache.count == 0

    ## test invalidate by module
    assert MemoizeTest.TestModule.testfun(1, 1) == 2
    assert MemoizeTest.TestModule2.testfun(1, 1) == 2
    assert Memoize.Cache.count == 2
    assert Memoize.invalidate(MemoizeTest.TestModule2, nil, nil) == true
    assert Memoize.Cache.count == 1

  end

  defmodule TestModule do

    import Memoize

    defmemoize testfun(a, b), do: a + b

    defmemoize testfun2(a, b), do: a * b

  end

  defmodule TestModule2 do

    import Memoize

    defmemoize testfun(a, b), do: a + b

  end

end
