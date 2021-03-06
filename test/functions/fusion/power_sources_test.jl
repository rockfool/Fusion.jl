@testset "Power Sources Function Tests" begin

  @test isdefined(Fusion, :power_sources) == true

  Fusion.load_input( "T_k = 15u\"keV\"" )

  scale_factor = 1u"MW"
  scale_factor *= Fusion.symbol_dict["R_0"] ^ 3
  scale_factor *= Fusion.symbol_dict["n_bar"] ^ 2

  actual_value = power_sources()
  actual_value /= scale_factor

  actual_value = calc_possible_values(actual_value)

  expected_value = P_F()
  expected_value *= Q_kernel()
  expected_value /= scale_factor

  expected_value = calc_possible_values(expected_value)

  @test isapprox( expected_value , actual_value , rtol=1e-2)

  expected_value = 6.888
  expected_value *= ( sigma_v_hat / 1u"m^3/s" )

  expected_value = calc_possible_values(expected_value)

  @test isapprox( expected_value , actual_value , rtol=1e-2)

end
