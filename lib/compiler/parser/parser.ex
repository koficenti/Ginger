defmodule Combinator do
  def new(str) do
    {"", str, :ok}
  end
  def fail({parsed, rest, _}) do
    {parsed, rest, :failed}
  end
  def ok({parsed, rest, _}) do
    {parsed, rest, :ok}
  end
  def sat({parsed, rest, _}, predicate) do
    char = String.at(rest, 0)
    if predicate.(char) do
      {parsed <> char, String.slice(rest, 1..-1), :ok}
    else
      {parsed, rest, :failed}
    end
  end
  def char(parser, char) do
    sat(parser, fn c -> c == char end)
  end

  def string(parser, "") do parser end
  def string({parsed, "", _result}, _str) do {parsed, "", :failed} end
  def string({parsed, rest, result}, str) when rest != "" do
    parser = {parsed, rest, result}

    if(String.length(str) > String.length(rest)) do
      parser
    end

    head = String.at(str, 0)
    tail = String.slice(str, 1..-1)

    {parsed, rest, result} = char(parser, head)

    case result do
      :ok ->
        tmp = string({parsed, rest, :ok}, tail)
        case tmp do
          {_, _, :failed} -> fail(parser)
          {_, _, :ok} -> tmp
        end
        :failed ->
          fail(parser)
        end

      end

      def string({parsed, rest, result}, str, :drop) do
        {_, rest, result} = string({parsed, rest, result}, str)
        {parsed, rest, result}
      end


      def many(parser, fun) do
        {parsed, rest, result} = fun.(parser)
        case result do
          :ok -> many({parsed, rest, result}, fun)
          :failed -> {parsed, rest, :ok}
    end
  end

  def many1(parser, fun) do
    {parsed, rest, result} = fun.(parser)
    case result do
      :ok -> many({parsed, rest, result}, fun)
      :failed -> {parsed, rest, :failed}
    end
  end

  def whitespace1({parsed, rest, result}) do
    {_, rest, result} = many1({parsed, rest, result}, fn p -> char(p, " ") end)
    {parsed, rest, result}
  end
  def whitespace({parsed, rest, result}) do
    {_, rest, result} = many({parsed, rest, result}, fn p -> char(p, " ") end)
    {parsed, rest, result}
  end

  def letter({parsed, rest, _result}) do
    head = String.at(rest, 0)
    tail = String.slice(rest, 1..-1)
    if head != nil and String.contains?("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", head) do
      {parsed <> head, tail, :ok}
    else
      {parsed, rest, :failed}
    end
  end
  def number({parsed, rest, _result}) do
    head = String.at(rest, 0)
    tail = String.slice(rest, 1..-1)
    if head != nil and String.contains?("1234567890", head) do
      {parsed <> head, tail, :ok}
    else
      {parsed, rest, :failed}
    end
  end


  def flush({_, rest, result}) do
    {"", rest, result}
  end

end
