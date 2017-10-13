@testset "Setup Given Equations Function Tests" begin

  @test isdefined(Tokamak, :setup_given_equations) == true

  Tokamak.load_input(" enable_radius_merging = false ")

  expected_value = 1.0

  test_T_range = [ 5.0 , 33.0 , 100.0 ]

  # -----------
  #  R_0 Tests
  # -----------

  # reversibility

  actual_value = Tokamak.setup_given_equations("steady", "wall")["R_0"]

  actual_value /= Tokamak.setup_given_equations("steady", "beta")["R_0"]

  actual_value = SymPy.N(actual_value)

  @test isapprox( actual_value, expected_value, rtol=1e-4 )

  # 1 - steady

  tmp_value = Tokamak.setup_given_equations("steady", "wall")["R_0"]

  tmp_value ^= 0.16

  tmp_value /= ( Tokamak.B_0 / 1u"T" ) ^ 0.15

  tmp_value /= Tokamak.G_1()

  tmp_value /= Tokamak.K_1()

  for cur_T_k in test_T_range
    actual_value = Tokamak.calc_possible_values(tmp_value, cur_T_k = cur_T_k * 1u"keV")

    @test isapprox( actual_value, expected_value, rtol=1e-4 )
  end

  # 2 - beta

  actual_value = Tokamak.setup_given_equations("beta", "steady")["R_0"]

  actual_value *= ( Tokamak.B_0 / 1u"T" )

  actual_value /= Tokamak.G_2()

  actual_value /= Tokamak.K_2()

  @test isapprox( actual_value, expected_value, rtol=1e-4 )

  # 3 - wall

  actual_value = Tokamak.setup_given_equations("wall", "steady")["R_0"]

  actual_value ^= 3

  actual_value /= Tokamak.G_3()

  actual_value /= Tokamak.K_3()

  @test isapprox( actual_value, expected_value, rtol=1e-4 )

  # -----------
  #  B_0 Tests
  # -----------

  # reversibility

  actual_value = Tokamak.setup_given_equations("wall", "beta")["B_0"]

  actual_value /= Tokamak.setup_given_equations("beta", "wall")["B_0"]

  @test isapprox( actual_value, expected_value, rtol=1e-4 )

  # 1 & 2 - steady + beta

  tmp_value = Tokamak.setup_given_equations("steady", "beta")["B_0"]

  tmp_value ^= ( 31 // 100 )

  tmp_value *= ( Tokamak.G_1() * Tokamak.K_1() )

  tmp_value /= ( Tokamak.G_2() * Tokamak.K_2() ) ^ ( 16 // 100 )

  for cur_T_k in test_T_range
    actual_value = Tokamak.calc_possible_values(tmp_value, cur_T_k = cur_T_k * 1u"keV")

    @test isapprox( actual_value, expected_value, rtol=1e-4 )
  end

  # 1 & 3 - steady + wall

  tmp_value = Tokamak.setup_given_equations("steady", "wall")["B_0"]

  tmp_value ^= ( 15 // 100 )

  tmp_value *= ( Tokamak.G_1() * Tokamak.K_1() )

  tmp_value /= ( Tokamak.G_3() * Tokamak.K_3() ) ^ ( 16 // 300 )

  for cur_T_k in test_T_range
    actual_value = Tokamak.calc_possible_values(tmp_value, cur_T_k = cur_T_k * 1u"keV")

    @test isapprox( actual_value, expected_value, rtol=1e-4 )
  end

end