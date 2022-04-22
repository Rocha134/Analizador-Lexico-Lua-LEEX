defmodule Myrex do
def process(filename) do
  File.read!(filename)
  |>to_charlist()
  |>:lexer.string()
end

def format(tokens) do
  Enum.map(tokens, fn {token, tkline, tchars} ->
    if token == :tab do
      {tkline, "&emsp;"}
    else
      {tkline, "<span class=#{token}>#{tchars}</span>"}
    end
  end)
end

def imprimir(lista, _contador, _file) when lista == [] do
  "Terminado"
end

def imprimir(lista, contador, file) do
  cont = contador
  if cont == elem(hd(lista), 0) do
    IO.binwrite(file, elem(hd(lista), 1))
    imprimir(tl(lista), cont, file)
  else
    cont = cont + 1
    IO.binwrite(file, "<br>")
    imprimir(lista, cont, file)
  end
end

def analizar(filename, outputname) do
  procesado = process(filename)
  formateado = format(elem(procesado, 1))
  File.rm(outputname)
  {:ok, archivo} = File.open(outputname, [:write])
  IO.binwrite(archivo, '<link rel = "stylesheet" href="coloreado.css">')
  IO.binwrite(archivo, '<body> <p>')
  x = imprimir(formateado, 1, archivo)
  IO.binwrite(archivo, '<p/> <body/>')
  File.close(archivo)
  x
end
end
