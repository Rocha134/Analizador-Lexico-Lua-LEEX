defmodule Myrex_sec do


  def generar(direccion) do
   x = Read.list_all(direccion)
   x
  macro_analizar(x)
  end

  def macro_analizar(lista) when lista == [] do
    "Acabado"
  end

  def macro_analizar(lista) do
    head = hd(lista)
    tail = tl(lista)
    output = hd(String.split(hd(Enum.take(String.split(head,"/"), -1)), "."))
    Myrex.analizar(head, "salidas/" <> output <> ".html")
    macro_analizar(tail)
  end


end
