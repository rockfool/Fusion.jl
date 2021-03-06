@testset "T Profile Function Tests" begin

  @test isdefined(Fusion, :T_profile) == true

  Fusion.load_input(" Z_eff = 1.0 ")
  Fusion.load_input(" n_bar = 0.86 * 1u\"n20\" ")
  Fusion.load_input(" B_0 = 10.0 * 1u\"T\" ")

  cur_solved_R_0 = 4.0
  cur_solved_T_k = 17.8

  test_hash = Dict(
    0.0 => 39.1600,
    0.5 => 27.7279,
    1.0 => 0.00000
  )

  for (cur_key, expected_value) in test_hash
    actual_value = T_profile(cur_key)

    actual_value = subs(
      actual_value, Fusion.symbol_dict["T_k"], cur_solved_T_k
    )

    @test isapprox(expected_value, actual_value, rtol=5e-4)
  end

end
