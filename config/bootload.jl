main_folder = pwd()

loaded_folders = [ "config/initializers", "src" ]

for loaded_folder in loaded_folders
  loaded_folder = "$main_folder/$loaded_folder"

  Julz.include_all_files(loaded_folder)
  @eval Julz.@export_all_files $loaded_folder
end

function load_input(raw_input, is_file=false)
  if is_file
    open("$main_folder/$raw_input") do file
      file_lines = map(x -> strip(x), readlines(file))
      raw_input = join(file_lines, ";")
    end
  end

  eval( parse(raw_input) )
end

defaults_file_name = "defaults.jl"
load_input(defaults_file_name, true)
