defmodule Myrex do
def process(filename) do
  File.read!(filename)
  |>to_charlist()
  |>:lexer.string()
end

end
