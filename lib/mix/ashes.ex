defmodule Mix.Ashes do 
  def copy_from(source_dir, target_dir, application_name, fun) do
    source_paths =
      source_dir
      |> Path.join("**/*")
      |> Path.wildcard(match_dot: true)

    for source_path <- source_paths do
      target_path = make_destination_path(source_path, source_dir,
                                          target_dir, application_name)

      cond do
        File.dir?(source_path) ->
          File.mkdir_p!(target_path)
        Path.basename(source_path) == ".keep" ->
          :ok
        true ->
          contents = fun.(source_path)
          Mix.Generator.create_file(target_path, contents)
      end
    end

    :ok
  end 
  
  def make_destination_path(source_path, source_dir, target_dir, {string_to_replace, name_of_generated}) do
    target_path =
      source_path
      |> String.replace(string_to_replace, String.downcase(name_of_generated))
      |> Path.relative_to(source_dir)
    Path.join(target_dir, target_path)
  end
end
