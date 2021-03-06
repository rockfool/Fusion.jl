"""
    @generate_magnet_equation_set

Lorem ipsum dolor sit amet.
"""
macro generate_magnet_equation_set(cur_R_0, cur_n_bar, cur_I_M)
  quote
    function (x, F)

      cur_solenoid_current = solenoid_current()

      cur_solenoid_length = solenoid_length()

      cur_hts_thickness = hts_thickness()

      # Flux Equation

      cur_left_part = standard_mu_0

      cur_left_part *= ( $(esc(cur_R_0)) / 1u"m" )

      cur_left_part *= magnet_li()

      cur_left_part *= ( $(esc(cur_I_M)) / 1u"A" )

      cur_left_part /= 2

      cur_right_part = x[1] ^ 2

      cur_right_part += x[2] ^ 2 / 6

      cur_right_part += x[1] * x[2] / 2

      cur_right_part *= -1

      cur_right_part *= pi

      cur_right_part *= magnet_B_1

      F[1] = cur_left_part + cur_right_part

      # Stress Equation

      cur_first_part = magnet_Sysol

      cur_second_part = pi

      cur_second_part *= magnet_B_1

      cur_second_part *= cur_solenoid_current

      cur_second_part /= 2

      cur_second_part /= cur_solenoid_length

      cur_second_part /= x[2]

      cur_second_part /= x[2] - cur_hts_thickness

      cur_second_part *= x[2] ^ 2/6 + x[2] * x[1] / 2

      cur_second_part *= -1

      cur_third_part = x[2] ^ 4/6

      cur_third_part += 2/3 * x[1] ^ 3 * x[2]

      cur_third_part += x[1] ^ 2 * x[2] ^ 2

      cur_third_part *= standard_mu_0

      cur_third_part *= cur_solenoid_current ^ 2

      cur_third_part /= 4

      cur_third_part /= cur_solenoid_length ^ 2

      cur_third_part /= x[2] ^ 2

      cur_denom = ( ( 2 * x[1] + x[2] ) - cur_hts_thickness ) ^ 2

      cur_denom -= ( ( 2 * x[1] + x[2] ) + cur_hts_thickness ) ^ 2

      cur_denom /= 4

      cur_denom += ( x[1] + x[2] ) ^ 2

      cur_denom -= x[1] ^ 2

      cur_third_part /= cur_denom

      cur_third_part *= -1

      if eltype(cur_second_part) == SymPy.Sym

        cur_second_part = subs(cur_second_part,
          symbol_dict["R_0"] => ( $(esc(cur_R_0)) / 1u"m" ),
          symbol_dict["n_bar"] => ( $(esc(cur_n_bar)) / 1u"n20" )
        )

      end

      if eltype(cur_third_part) == SymPy.Sym

        cur_third_part = subs(cur_third_part,
          symbol_dict["R_0"] => ( $(esc(cur_R_0)) / 1u"m" ),
          symbol_dict["n_bar"] => ( $(esc(cur_n_bar)) / 1u"n20" )
        )

      end

      F[2] = cur_first_part + cur_second_part + cur_third_part

    end
  end
end
