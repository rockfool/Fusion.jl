"""
    K_BR()

Lorem ipsum dolor sit amet.
"""
function K_BR()
  cur_K_BR = enable_bremsstrahlung ? 0.1056 : 0.0

  cur_K_BR *= BR_scaling

  cur_K_BR *= ( 1 + nu_n ) ^ 2
  cur_K_BR *= ( 1 + nu_T ) ^ (1/2)
  cur_K_BR /= 1 + 2 * nu_n + (1/2) * nu_T

  cur_K_BR *= Z_eff
  cur_K_BR *= epsilon ^ 2
  cur_K_BR *= kappa

  cur_K_BR
end
