defmodule BiMultiMapPropertiesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  require BiMultiMap

  property "finds present items in bimultimap" do
    check all key_set <- nonempty(list_of(term())),
              value_set <- list_of(term(), length: Enum.count(key_set)) do
      kv_list = Enum.zip(key_set, value_set) |> MapSet.new()
      bimultimap = BiMultiMap.new(kv_list)
      {random_key, random_value} = Enum.random(bimultimap)

      kv_list_values =
        kv_list
        |> Enum.filter(fn {k, _v} -> k === random_key end)
        |> Enum.map(fn {_k, v} -> v end)

      kv_list_keys =
        kv_list
        |> Enum.filter(fn {_k, v} -> v === random_value end)
        |> Enum.map(fn {k, _v} -> k end)

      {:ok, bimultimap_values} = BiMultiMap.fetch(bimultimap, random_key)
      {:ok, bimultimap_keys} = BiMultiMap.fetch_keys(bimultimap, random_value)

      assert bimultimap_values |> Enum.sort() == kv_list_values |> Enum.sort()
      assert bimultimap_keys |> Enum.sort() == kv_list_keys |> Enum.sort()
    end
  end

  property "deletes items from bimultimap" do
    check all key_set <- nonempty(list_of(term())),
              value_set <- list_of(term(), length: Enum.count(key_set)) do
      kv_list = Enum.zip(key_set, value_set) |> MapSet.new()
      bimultimap = BiMultiMap.new(kv_list)
      {random_key, random_value} = Enum.random(bimultimap)

      bimultimap_comparison_delete_keys =
        kv_list
        |> Enum.reject(fn {k, _v} -> k === random_key end)
        |> BiMultiMap.new()

      bimultimap_comparison_delete_values =
        kv_list
        |> Enum.reject(fn {_k, v} -> v === random_value end)
        |> BiMultiMap.new()

      deleted_key_bimultimap = BiMultiMap.delete_key(bimultimap, random_key)
      deleted_value_bimultimap = BiMultiMap.delete_value(bimultimap, random_value)

      assert BiMultiMap.equal?(deleted_value_bimultimap, bimultimap_comparison_delete_values)
      assert BiMultiMap.equal?(deleted_key_bimultimap, bimultimap_comparison_delete_keys)
    end
  end

  property "it turns bimultimaps into lists" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- list_of(term(), length: Enum.count(key_set)) do
      kv_list = Enum.zip(key_set, value_set) |> MapSet.new()
      bimultimap = BiMultiMap.new(kv_list)

      assert BiMultiMap.to_list(bimultimap) |> MapSet.new() == kv_list
    end
  end

  property "it puts items into bimultimaps" do
    check all key_set <- nonempty(uniq_list_of(term())),
              value_set <- list_of(term(), length: Enum.count(key_set)),
              random_key <- term(),
              random_value <- term() do
      kv_list = Enum.zip(key_set, value_set) |> MapSet.new()
      bimultimap = BiMultiMap.new(kv_list)

      put_kv_list = MapSet.put(kv_list, {random_key, random_value})
      put_bimultimap = BiMultiMap.put(bimultimap, random_key, random_value)

      assert BiMultiMap.equal?(put_bimultimap, BiMultiMap.new(put_kv_list))
    end
  end
end
