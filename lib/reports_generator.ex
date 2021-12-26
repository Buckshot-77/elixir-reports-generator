defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  def build(filename) do
    result =
      filename
      |> Parser.parse_file()
      |> Enum.reduce(report_accumulator(), fn line, report -> sum_values(line, report) end)

    {:ok, result}
  end

  def build_from_many(filename_list) when not is_list(filename_list) do
    {:error, "Please provide a list containing the file paths to be read."}
  end

  def build_from_many(filename_list) do
    filename_list
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_accumulator(), fn {:ok, result}, report ->
      sum_reports(result, report)
    end)
  end

  def fetch_highest_spender_or_most_sold({:ok, report}, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_highest_spender_or_most_sold(_report, _option), do: {:error, "Invalid option!"}

  defp sum_reports({:ok, %{"users" => users1, "foods" => foods1}}, %{
         "users" => users2,
         "foods" => foods2
       }) do
    foods = merge_maps(foods1, foods2)

    users = merge_maps(users1, users2)

    build_report(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 ->
      value1 + value2
    end)
  end

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    update_map(report, users, foods)
  end

  defp update_map(report, users, foods) do
    report
    |> Map.put("users", users)
    |> Map.put("foods", foods)
  end

  defp report_accumulator do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"foods" => foods, "users" => users}
end
