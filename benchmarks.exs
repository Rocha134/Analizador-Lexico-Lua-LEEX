
Benchee.run(%{
  "concurrente"    => fn -> Myrex_conc.generar("pruebas") end,
  "secuencial" => fn -> Myrex_sec.generar("pruebas") end,
  "normal" => fn -> Myrex.main("pruebas/main.lua") end
})
