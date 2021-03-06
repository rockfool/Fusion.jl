"""
    run_parameter_sweep(T_list, swept_params...; verbose=true)

Lorem ipsum dolor sit amet.
"""
function run_parameter_sweep(T_list, swept_params...; verbose=true)
  if isempty(swept_params)
    return sweep_T_k(T_list; verbose=verbose)
  end

  cur_variable, cur_range = first(swept_params)

  cur_output = OrderedDict()

  for cur_value in cur_range
    if isa(cur_value, AbstractString)
      cur_value = "\"$cur_value\""
    end

    cur_input = "$cur_variable = $cur_value"

    if verbose ; println(" \n\n $cur_input \n ") ; end

    Fusion.load_input(cur_input)

    cur_output[cur_input] = run_parameter_sweep(T_list, swept_params[2:end]..., verbose=verbose)
  end

  cur_output
end
