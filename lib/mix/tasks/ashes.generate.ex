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
    Mix.Tasks.Ecto.Gen.Migration.run([name])
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

    source_path = Path.expand((options[:template] || options[:model_template] || Path.join(template_dir("models"), "name.ex")))
    target_dir = "./web/models"
    copy_from source_path, target_dir, (options[:filename] || {"name", model_name}), &EEx.eval_file(&1, binding)
  end

  # Generate a controller
  def controller(name, options) do
    controller_name = Naming.camelize(name)

    binding = [application_name: application_name,
               controller: name,
               controller_name: controller_name,
               options: options]

    controller_source_path = Path.expand((options[:template] || options[:controller_template] || Path.join(template_dir("controllers"), "name_controller.ex")))
    view_source_path = Path.expand((options[:view_template] || Path.join(template_dir("views"), "name_view.ex")))
    controllers_dir = "./web/controllers"
    views_dir = "./web/views"
    copy_from controller_source_path, controllers_dir, (options[:filename] || options[:controller_filename] || {"name", controller_name}), &EEx.eval_file(&1, binding)

    if !options[:skip_view] do 
      copy_from view_source_path, views_dir, (options[:view_filename] || {"name", controller_name }), &EEx.eval_file(&1, binding)
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

    source_path = Path.expand((options[:template] || options[:channel_template] || Path.join(template_dir("channels"), "name_channel.ex")))
    target_dir = "./web/channels"
    copy_from source_path, target_dir, (options[:filename] || options[:channel_filename] || {"name", channel_name}), &EEx.eval_file(&1, binding)

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
    "#{Mix.Project.deps_path}/ashes/templates/#{type}"
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

        socket "/ws", #{application_name} do
          channel "#{name}", #{module}
        end
      """
    end
  end
end


defmodule Mix.Tasks.Ashes.G do
  def run(args), do: Mix.Tasks.Ashes.Generate.run(args)
end

defmodule Mix.Tasks.Ashes.Gen do
  def run(args), do: Mix.Tasks.Ashes.Generate.run(args)
end
