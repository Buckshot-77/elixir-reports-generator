# ReportsGenerator

The project generates a report containing the most consumed food and the client who spent the most, taking the data from files which are included in the project.

Running
```elixir
ReportsGenerator.build("report_complete.csv")
```
will build the report using a single process for it

And running
```elixir
ReportsGenerator.build_from_many(["report_1.csv", "report_2.csv", "report_3.csv"])
```
will build the report using one process for each file, but still resulting in a single report at the end.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `reports_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reports_generator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/reports_generator>.

