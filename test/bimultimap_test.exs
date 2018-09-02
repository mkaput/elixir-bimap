defmodule BiMultiMapTest do
  use ExUnit.Case, async: true
  doctest BiMultiMap

  test "size is correctly computed on put" do
    # we can't use new/1 here, because it may compute size on its own
    map =
      BiMultiMap.new()
      |> BiMultiMap.put(:a, 1)
      |> BiMultiMap.put(:a, 2)
      |> BiMultiMap.put(:b, 2)

    assert BiMultiMap.size(map) == 3
  end

  test "size is correclty computed on new/1" do
    map = BiMultiMap.new(a: 1, b: 2, c: 2)
    assert BiMultiMap.size(map) == 3
  end

  test "size is correclty computed on delete/3" do
    map = BiMultiMap.new(a: 1, b: 2, c: 2)
    assert BiMultiMap.size(map) == 3
    map = BiMultiMap.delete(map, :b, 2)
    assert BiMultiMap.size(map) == 2
    map = BiMultiMap.delete(map, :c, 2)
    assert BiMultiMap.size(map) == 1
    map = BiMultiMap.delete(map, :a, 1)
    assert BiMultiMap.size(map) == 0
  end

  test "delete/3 removes empty value sets" do
    map = BiMultiMap.new(a: 1, a: 2)
    assert BiMultiMap.has_key?(map, :a)
    map = BiMultiMap.delete(map, :a, 1)
    assert BiMultiMap.has_key?(map, :a)
    map = BiMultiMap.delete(map, :a, 2)
    refute BiMultiMap.has_key?(map, :a)
  end

  test "delete/3 removes empty key sets" do
    map = BiMultiMap.new(a: 1, b: 1)
    assert BiMultiMap.has_value?(map, 1)
    map = BiMultiMap.delete(map, :a, 1)
    assert BiMultiMap.has_value?(map, 1)
    map = BiMultiMap.delete(map, :b, 1)
    refute BiMultiMap.has_value?(map, 1)
  end
end
