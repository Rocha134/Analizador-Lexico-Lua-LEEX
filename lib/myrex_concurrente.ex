defmodule Myrex_conc do

  def generar(direccion) do
    x = Read.list_all(direccion)
   conc_analisis(x)
   end


  def nombrar(direccion) do
    hd(String.split(hd(Enum.take(String.split(direccion,"/"), -1)), "."))
  end

  def conc_analisis(lista) when lista == [] do
  "Acabado"
  end

  def conc_analisis(lista) do
    head = hd(lista)
    tail = tl(lista)
    output = nombrar(head)
    Task.start(fn -> Myrex.analizar(head, "salidas_conc/" <> output <> ".html") end)
    conc_analisis(tail)
  end

end
