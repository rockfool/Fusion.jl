@testset "Simplified Density Function Tests" begin

  @test isdefined(Tokamak, :simplified_density) == true

  actual_value = Tokamak.simplified_density()
  actual_value *= Sym("R_0") ^ 2

  expected_value = 1.917 * Tokamak.N_G
  expected_value *= ( Tokamak.sigma_v_hat() / 1u"m^3/s" )

  expected_value = 1.591 / ( 1 - expected_value )
  expected_value *= Tokamak.N_G^2
  expected_value *= ( Tokamak.T_k / 1u"keV" )

  @test isapprox( expected_value, actual_value , rtol=5e-1 )

end