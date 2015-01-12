defmodule Mix.Tasks.Ashes.Generate do
  use Mix.Task
  alias Phoenix.Naming
  import Mix.Ashes

  def run(args) do 
    {opts, [type, name | rest], _} = OptionParser.parse(args)
    apply(__MODULE__, String.to_atom(type), [name, rest, opts])
  end

  # Generate an ecto migration
  def migration(name) do
    Mix.Tasks.Ecto.Gen.Migration.run(["#{application_name}.Repo", name])
  end
  def migration(name, _, _), do: migration(name)

  # Generate an ecto model
  def model(name, schema, options) do
    model_name = Naming.camelize(name)

    binding = [application_name: application_name,
               model: name,
               model_name: model_name,
               model_plural: "#{name}s",
               schema: schema,
               options: options]

    copy_from template_dir("models"), "./web/models", {"model_name", model_name}, &EEx.eval_file(&1, binding)
  end

  # Generate a controller
  def controller(name, options) do
    controller_name = Naming.camelize(name)

    binding = [application_name: application_name,
               controller: name,
               controller_name: controller_name,
               options: options]

    copy_from template_dir("controllers"), "./web/controllers", {"controller_name", controller_name}, &EEx.eval_file(&1, binding)
    if !options[:skip_view] do 
      copy_from template_dir("views"), "./web/views", {"controller_name", controller_name }, &EEx.eval_file(&1, binding)
    end
    if !options[:skip_template] do 
      Mix.Generator.create_directory("./web/templates/#{name}")
    end

    module_name = "#{controller_name}Controller"
    Mix.Shell.IO.info """

      Make sure to add your controller to web/routes.ex

        resources "/#{name}", #{module_name} 

        or

        get "/#{name}", #{module_name},  :index
        post "/#{name}", #{module_name}, :create
        put "/#{name}/:id", #{module_name},  :edit
        delete "/#{name}/:id, #{module_name}, :delete
        etc...
    """
  end
  def controller(name, _, options), do: controller(name, options)

  # Generate a channel
  def channel(name, events, options) do
    channel_name = Naming.camelize(name)

    binding = [application_name: application_name,
               channel: name,
               channel_name: channel_name,
               events: events,
               options: options]

    copy_from template_dir("channels"), "./web/channels", {"channel_name", channel_name}, &EEx.eval_file(&1, binding)
    insert_channel name, "#{channel_name}Channel"
  end

  # Generate a resource
  def resource(name, schema, options) do
    model(name, schema, options)
    controller(name, options)
  end

  # Helpers
  defp application_name do 
    Naming.camelize(Mix.Project.config()[:app])
  end

  defp template_dir(type) do 
    Application.app_dir(:phoenix, "templates/#{type}")
  end

  defp insert_channel(name, module) do
    router = File.read!(Path.join("web","router.ex"))
    {_, matcher} = Regex.compile("socket \".+\", #{application_name}")
    if Regex.run(matcher, router) do
      Mix.Shell.IO.info """

        Make sure to add a channel in web/routes.ex
        
          channel "#{name}", #{module}
      """
    else
      Mix.Shell.IO.info """

      Make sure to add a channel in web/routes.ex

        socket "/ws", #{application_name}
          channel "#{name}", #{module}
        end
      """
    end
  end
end

