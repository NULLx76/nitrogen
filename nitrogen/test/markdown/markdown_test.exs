defmodule Markdown.BencheeTest do
  use ExUnit.Case

  @tag :benchmark
  test "markdown benchmark" do
    Benchee.run(
      %{
        "markdown_rs" => fn input -> Markdown.render_simple(input) end,
        "earmark" => fn input -> Earmark.as_html!(input) end
      },
      inputs: %{
        "simple test" => "# Yeet",
        "simple local link" => "[example](/example)",
        "complex file" => File.read!("./test/markdown/test.md")
      }
    ).scenarios
    |> Enum.map(&%{name: &1.name, avg: &1.run_time_data.statistics.average, input: &1.input_name})
    |> Enum.chunk_by(& &1.input)
    |> Enum.each(fn
      [a, b] when a.name == "markdown_rs" -> assert a.avg < b.avg, "Rust parser should be faster"
      [a, b] when a.name == "earmark" -> assert b.avg < a.avg, "Rust parser should be faster"
    end)
  end
end
