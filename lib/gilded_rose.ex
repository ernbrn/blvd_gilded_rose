defmodule GildedRose do
  use Agent
  alias GildedRose.Item

  @callback update_item(%GildedRose.Item{}) :: %GildedRose.Item{}

  def new() do
    {:ok, agent} =
      Agent.start_link(fn ->
        [
          Item.new("+5 Dexterity Vest", 10, 20),
          Item.new("Aged Brie", 2, 0),
          Item.new("Elixir of the Mongoose", 5, 7),
          Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
          Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
          Item.new("Conjured Mana Cake", 3, 6)
        ]
      end)

    agent
  end

  def update_item!({item, index}) do
    {update_for(item.name).update_item(item), index}
  end

  def items(agent), do: Agent.get(agent, & &1)

  def update_quality(agent) do
    agent
    |> items()
    |> Enum.with_index()
    |> Task.async_stream(&update_item!/1)
    |> Enum.each(fn {:ok, {item, index}} ->
      Agent.update(agent, &List.replace_at(&1, index, item))
    end)

    :ok
  end

  defp update_for("Aged Brie"), do: Item.AgedBrie
  defp update_for("Backstage passes " <> _), do: Item.BackstagePasses
  defp update_for("Sulfuras, Hand of Ragnaros"), do: Item.Sulfuras
  defp update_for(_), do: Item.StandardItem
end
