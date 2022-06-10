
Benchee.run(%{
  "concurrente"    => fn -> Myrex_conc.generar("pruebas") end,
  "secuencial" => fn -> Myrex_sec.generar("pruebas") end
},
formatters: [
  Benchee.Formatters.HTML,
  Benchee.Formatters.Console
],
time: 180
)
