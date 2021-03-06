"""
    converge_eta_CD(main_value, given_equations, cur_eta_CD, side_guess=15.0; verbose=false)

Lorem ipsum dolor sit amet.
"""
function converge_eta_CD(main_value, given_equations, cur_eta_CD, side_guess=15.0; verbose=false)
  cur_solved_R_0 = NaN
  cur_solved_B_0 = NaN
  cur_solved_T_k = NaN

  cur_rho_j = NaN

  has_converged = false

  attempt_bank = []

  min_weight = 0.3

  init_eta_CD = cur_eta_CD
  prev_eta_CD = cur_eta_CD
  work_eta_CD = cur_eta_CD

  if main_variable == side_variable
    error("Main variable can not be the same as the side variable")
  end

  if main_variable == "T_k"
    cur_solved_T_k = main_value
  elseif main_variable == "B_0"
    cur_solved_B_0 = main_value
  else
    error("Invalid main variable selection")
  end

  cur_equations = copy(given_equations)

  for (cur_key, cur_value) in cur_equations
    for (cur_sub_key, cur_sub_value) in constraint_params
      cur_value = subs(
        cur_value,
        symbol_dict[cur_sub_value] => eval(parse("max_$(cur_sub_value)"))
      )
    end

    cur_equations[cur_key] = subs(
      cur_value, symbol_dict[main_variable] => main_value
    )
  end

  while length(attempt_bank) < convergence_attempt_counts

    if side_variable == "T_k"
      cur_solved_T_k = solved_T_k_from_constraint(main_value, side_guess, work_eta_CD, cur_equations["B_0"]/main_value - 1.0, verbose) / 1u"keV"
    elseif side_variable == "B_0"
      cur_solved_B_0 = solved_B_0_from_constraint(main_value, side_guess, work_eta_CD, cur_equations["B_0"], verbose) / 1u"T"
    else
      error("Invalid side variable selection")
    end

    is_bad_attempt = ( isnan(cur_solved_T_k) || isnan(cur_solved_B_0) )
    is_bad_attempt |= ( !isreal(cur_solved_T_k) || !isreal(cur_solved_B_0) )

    if is_bad_attempt
      if verbose ; print("x") ; end
      append!(attempt_bank, [ NaN for i in 1:( convergence_attempt_counts - length(attempt_bank) ) ])
      continue
    end

    cur_solved_R_0 = subs(
      cur_equations["R_0"],
      symbol_dict["B_0"] => cur_solved_B_0
    )

    cur_solved_R_0 = calc_possible_values(
      cur_solved_R_0,
      cur_T_k = ( cur_solved_T_k * 1u"keV" ),
      cur_eta_CD=work_eta_CD
    )

    if !enable_eta_CD_derive
      has_converged = true
      cur_rho_j = 0.0
    end

    has_converged && break

    tmp_eta_CD, cur_rho_j = get_new_eta_CD(cur_solved_R_0, main_value, cur_solved_T_k, work_eta_CD, verbose=verbose)

    is_bad_eta_CD = isnan(tmp_eta_CD)
    is_bad_eta_CD |= eltype(tmp_eta_CD) == SymPy.Sym && is_real(tmp_eta_CD) == nothing

    new_weight = 1 - min_weight
    new_weight *= sqrt( length(attempt_bank) / convergence_attempt_counts )
    new_weight += min_weight

    push!(attempt_bank, work_eta_CD)

    if is_bad_eta_CD
      if verbose ; print("#") ; end

      if prev_eta_CD == cur_eta_CD
        append!(attempt_bank, [ NaN for i in 1:( convergence_attempt_counts - length(attempt_bank) ) ])
      end

      work_eta_CD *= ( 1 - new_weight )
      work_eta_CD += init_eta_CD * new_weight

      continue
    end

    prev_eta_CD = cur_eta_CD
    cur_eta_CD = tmp_eta_CD

    rel_error =
      abs( cur_eta_CD - prev_eta_CD ) /
      min( cur_eta_CD , prev_eta_CD )

    has_converged = ( rel_error < wave_error_level )

    if has_converged
      work_eta_CD = cur_eta_CD
      continue
    end

    work_eta_CD *= ( 1 - new_weight )
    work_eta_CD += cur_eta_CD * new_weight

  end

  output = Array{Any}(1, 6)

  if !has_converged
    if any(cur_attempt -> !isnan(cur_attempt), attempt_bank)
      verbose && println("\nFailed to converge eta CD: \n$(unique(attempt_bank))\n")
    end

    fill!(output,  NaN)
    output[6] = false

    return output
  end

  verbose && print("✓")

  output[1:3] = [
    cur_solved_R_0,
    cur_solved_B_0,
    cur_solved_T_k
  ]

  output[4:5] = [
    SymPy.N(cur_eta_CD),
    SymPy.N(cur_rho_j)
  ]

  output[6] = true

  return output

end
