defmodule GildedRoseTest do
  use ExUnit.Case, async: true
  doctest GildedRose

  @item_name_with_normal_behavior "Regular item"
  @aged_brie "Aged Brie"
  @sulfuras "Sulfuras, Hand of Ragnaros"
  @backstage_pass "Backstage passes to a TAFKAL80ETC concert"
  @conjured "Conjured"

  describe "update_quality/1" do
    test "interface specification" do
      gilded_rose = GildedRose.new()
      [%GildedRose.Item{} | _] = GildedRose.items(gilded_rose)
      assert :ok == GildedRose.update_quality(gilded_rose)
    end
  end

  describe "update_quality/1 when item has normal behavior" do
    test "quality and sell-in should decrease by 1 every day" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @item_name_with_normal_behavior, sell_in: 10, quality: 20}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @item_name_with_normal_behavior, sell_in: 9, quality: 19}] =
               GildedRose.items(store)

      Agent.stop(store)
    end

    test "when sell_in days is less than 0, quality degrades twice as fast" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @item_name_with_normal_behavior, sell_in: -1, quality: 20}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @item_name_with_normal_behavior, quality: 18}] =
               GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality should not drop below 0" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @item_name_with_normal_behavior, sell_in: -1, quality: 0}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @item_name_with_normal_behavior, quality: 0}] =
               GildedRose.items(store)

      Agent.stop(store)
    end
  end

  describe "update_quality/1 when item is Aged Brie" do
    test "when sell_in date is greater than 0, quality should increase by 1" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @aged_brie, sell_in: 10, quality: 10}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @aged_brie, quality: 11}] = GildedRose.items(store)

      Agent.stop(store)
    end

    test "when sell_in is <= 0 quality should increase twice as fast" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @aged_brie, sell_in: 0, quality: 10}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @aged_brie, quality: 12}] = GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality should not increase above 50" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @aged_brie, sell_in: 10, quality: 50}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @aged_brie, quality: 50}] = GildedRose.items(store)

      Agent.stop(store)
    end
  end

  describe "update_quality/1 when the item is Sulfuras" do
    test "quality will not change" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @sulfuras, sell_in: 10, quality: 80}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @sulfuras, quality: 80}] = GildedRose.items(store)

      Agent.stop(store)
    end
  end

  describe "update_quality/1 when the item is Backstage passes" do
    test "quality increases by 1 when sell_in > 10" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @backstage_pass, sell_in: 11, quality: 10}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, quality: 11}] = GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality increases by 2 when sell_in is between 10 and 6" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @backstage_pass, sell_in: 10, quality: 10}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 9, quality: 12}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 8, quality: 14}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 7, quality: 16}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 6, quality: 18}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 5, quality: 20}] =
               GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality increases by 3 when sell_in is between 5 and 0" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @backstage_pass, sell_in: 5, quality: 20}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 4, quality: 23}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 3, quality: 26}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 2, quality: 29}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 1, quality: 32}] =
               GildedRose.items(store)

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: 0, quality: 35}] =
               GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality drops to 0 after the concert" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @backstage_pass, sell_in: 0, quality: 35}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @backstage_pass, sell_in: -1, quality: 0}] =
               GildedRose.items(store)

      Agent.stop(store)
    end
  end

  describe "update_quality/1 when item is Conjured" do
    test "quality degrades twice as fast" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @conjured, sell_in: 10, quality: 10}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @conjured, sell_in: 9, quality: 8}] = GildedRose.items(store)

      Agent.stop(store)
    end

    test "quality never drops below 0" do
      store =
        start_test_agent([
          %GildedRose.Item{name: @conjured, sell_in: -1, quality: 0}
        ])

      GildedRose.update_quality(store)

      assert [%GildedRose.Item{name: @conjured, sell_in: -2, quality: 0}] =
               GildedRose.items(store)

      Agent.stop(store)
    end
  end

  defp start_test_agent(items) do
    {:ok, agent} = Agent.start_link(fn -> items end)
    agent
  end
end
