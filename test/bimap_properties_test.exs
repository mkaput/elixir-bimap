defmodule BiMapPropertiesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  property "finds present items in bimap" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- uniq_list_of(term(), length: Enum.count(key_set)) do
      regular_map = Enum.zip(key_set, value_set) |> Enum.into(%{})
      bimap = BiMap.new(regular_map)
      {random_key, random_value} = Enum.random(regular_map)

      assert BiMap.fetch(bimap, random_key) == {:ok, random_value}
      assert BiMap.fetch_key(bimap, random_value) == {:ok, random_key}
    end
  end

  property "deletes items from bimap" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- uniq_list_of(term(), length: Enum.count(key_set)) do
      regular_map = Enum.zip(key_set, value_set) |> Enum.into(%{})
      bimap = BiMap.new(regular_map)
      {random_key, random_value} = Enum.random(regular_map)

      assert BiMap.equal?(
               BiMap.delete(bimap, {random_key, random_value}),
               Map.delete(regular_map, random_key) |> BiMap.new()
             )

      assert BiMap.equal?(
               BiMap.delete(bimap, random_key, random_value),
               Map.delete(regular_map, random_key) |> BiMap.new()
             )

      assert BiMap.equal?(
               BiMap.delete_key(bimap, random_key),
               Map.delete(regular_map, random_key) |> BiMap.new()
             )

      assert BiMap.equal?(
               BiMap.delete_value(bimap, random_value),
               Map.delete(regular_map, random_key) |> BiMap.new()
             )
    end
  end

  property "it turns bimaps into lists" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- uniq_list_of(term(), length: Enum.count(key_set)) do
      regular_map = Enum.zip(key_set, value_set) |> Enum.into(%{})
      bimap = BiMap.new(regular_map)

      assert BiMap.to_list(bimap) |> MapSet.new() == Map.to_list(regular_map) |> MapSet.new()
    end
  end

  property "it puts items into bimaps" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- uniq_list_of(term(), length: Enum.count(key_set)),
              random_key <- term(),
              random_value <- term() do
      regular_map = Enum.zip(key_set, value_set) |> Enum.into(%{})
      bimap = BiMap.new(regular_map)

      put_regular_map =
        regular_map
        |> Enum.reject(fn {_, v} -> v == random_value end)
        |> Enum.into(%{})
        |> Map.put(random_key, random_value)

      put_bimap = BiMap.put(bimap, random_key, random_value)

      assert BiMap.equal?(put_bimap, BiMap.new(put_regular_map))
    end
  end
end
