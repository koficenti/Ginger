defmodule Ginger do
  use Application
  alias Combinator

  def start(_type, _args) do
    main()
    Supervisor.start_link([], [strategy: :one_for_one])
  end

  def parse(str) do
    {left, rest, result1} = Combinator.new(str)
    |> Combinator.string("let") |> Combinator.flush
    |> Combinator.whitespace1
    |> Combinator.many1(&(Combinator.letter(&1)))
    |> Combinator.whitespace1
    |> Combinator.string("=", :drop)
    |> Combinator.whitespace1

    {right, _, result2} = Combinator.new(rest)
    |> Combinator.many1(&(Combinator.number(&1)))
    |> Combinator.whitespace
    |> Combinator.string(";", :drop)

    if result1 == :ok && result2 == :ok do
      IO.puts("Input -> ' #{str} '\nName: #{left} /  Value: #{right}\n")
    else
      IO.puts("error -> #{str}\n")
    end
  end

  def main do
    parse("let x = 10;")
    parse("let x = 10")
    parse("let apple = 200;")


  end

end
