defmodule Mix.Ashes do 
  
  def copy_from(source_path, target_dir, application_name, fun) do

    target_path = case application_name do
      {_,_} -> make_destination_path(source_path, target_dir, application_name)
      x -> Path.expand(Path.join(target_dir, application_name))
    end

    cond do
      File.dir?(source_path) ->
        File.mkdir_p!(target_path)
      Path.basename(source_path) == ".keep" ->
        :ok
      true ->
        contents = fun.(source_path)
        Mix.Generator.create_file(target_path, contents)
    end

    :ok
  end 

  def make_destination_path(source_path, target_dir, {string_to_replace, name_of_generated}) do
    target_path =
      source_path
      |> String.replace(string_to_replace, String.downcase(name_of_generated))
      |> Path.basename
    Path.expand(Path.join(target_dir, target_path))
  end

end
