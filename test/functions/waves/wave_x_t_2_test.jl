@testset "Wave X T 2 Function Tests" begin

  @test isdefined(Fusion, :wave_x_t_2) == true

  Fusion.load_input(" Z_eff = 1.0 ")
  Fusion.load_input(" n_bar = 0.86 * 1u\"n20\" ")
  Fusion.load_input(" B_0 = 10.0 * 1u\"T\" ")
  Fusion.load_input(" R_0 = 4.0 * 1u\"m\" ")
  Fusion.load_input(" T_k = 17.8 * 1u\"keV\" ")

  cur_n_para_m = 1.473416371493217
  cur_rho_m = 0.773925336996854

  expected_value = 37.501360021554007

  actual_value = subs(
    wave_x_t_2(cur_rho_m),
    Fusion.symbol_dict["n_para"],
    cur_n_para_m
  )

  @test isapprox(expected_value, actual_value, rtol=5e-4)

end
