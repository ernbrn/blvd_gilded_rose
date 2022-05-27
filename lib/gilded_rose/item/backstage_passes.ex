defmodule GildedRose.Item.BackstagePasses do
  @quality_adjustment_value 1
  @sell_in_adjustment_value -1
  @behaviour GildedRose

  @impl GildedRose
  def update_item(item) do
    item
    |> adjust_quality()
    |> adjust_sell_in()
  end

  defp adjust_quality(%{sell_in: sell_in, quality: quality} = item) when sell_in > 10 do
    %{item | quality: quality + @quality_adjustment_value}
  end

  defp adjust_quality(%{sell_in: sell_in, quality: quality} = item)
       when sell_in <= 10 and sell_in >= 6 do
    %{item | quality: quality + @quality_adjustment_value * 2}
  end

  defp adjust_quality(%{sell_in: sell_in, quality: quality} = item)
       when sell_in <= 5 and sell_in > 0 do
    %{item | quality: quality + @quality_adjustment_value * 3}
  end

  defp adjust_quality(item) do
    %{item | quality: 0}
  end

  defp adjust_sell_in(%{sell_in: sell_in} = item) do
    %{item | sell_in: sell_in + @sell_in_adjustment_value}
  end
end
