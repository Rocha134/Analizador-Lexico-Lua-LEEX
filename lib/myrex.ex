defmodule Myrex do
def process(filename) do
  File.read!(filename)
  |>to_charlist()
  |>:lexer.string()
end

def format(tokens) do
  Enum.map(tokens, fn {token, tkline, tchars} ->
    {tkline, "<span class=#{token}>#{tchars}</span>"}
  end)
end

end
