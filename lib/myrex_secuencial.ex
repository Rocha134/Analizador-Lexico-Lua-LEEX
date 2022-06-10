defmodule Myrex_sec do


  def generar(direccion) do
   x = Read.list_all(direccion)
   x
  macro_analizar(x)
  end

  def macro_analizar(lista) when lista == [] do
    "Acabado"
  end

  def nombrar(direccion) do
    hd(String.split(hd(Enum.take(String.split(direccion,"/"), -1)), "."))
  end

  def macro_analizar(lista) do
    head = hd(lista)
    tail = tl(lista)
    output = nombrar(head)
    Myrex.analizar(head, "salidas_sec/" <> output <> ".html")
    macro_analizar(tail)
  end


end
