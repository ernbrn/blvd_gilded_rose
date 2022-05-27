defmodule GildedRose.Item.Conjured do
  @quality_adjustment_value -2
  @sell_in_adjustment_value -1
  @behaviour GildedRose

  @impl GildedRose
  def update_item(item) do
    item
    |> adjust_quality()
    |> adjust_sell_in()
  end

  defp adjust_quality(%{quality: 0} = item) do
    item
  end

  defp adjust_quality(%{quality: quality} = item) do
    %{item | quality: quality + @quality_adjustment_value}
  end

  defp adjust_sell_in(%{sell_in: sell_in} = item) do
    %{item | sell_in: sell_in + @sell_in_adjustment_value}
  end
end
