Code.require_file "../../mix_helper.exs", __DIR__

defmodule Mix.Tasks.Ashes.GenerateTest do
  use ExUnit.Case

  import MixHelper
  import ExUnit.CaptureIO

  @app_name  "photo_blog"
  @tmp_path  tmp_path()
  @project_path Path.join(@tmp_path, @app_name)

  setup_all do
    templates_path = Path.join([@project_path, "deps", "ashes", "templates"])
    root_path =  File.cwd!

    #Clean up
    File.rm_rf @project_path

    #Create path for app
    File.mkdir_p Path.join(@project_path, "web")

    #Copy fixture router into web directory
    File.cp! Path.join([root_path, "test", "fixtures", "router.ex"]), Path.join([@project_path, "web", "router.ex"])

    #Create path for templates
    File.mkdir_p templates_path

    #Copy templates into `deps/ashes/templates` to mimic a real Phoenix application
    File.cp_r! Path.join(root_path, "templates"), templates_path

    #Move into the project directory to run the generator
    File.cd! @project_path
  end

  test "creates controller files and directories" do
    Mix.Tasks.Ashes.Generate.run(["controller", "user"])
    assert_file "web/controllers/user_controller.ex"

    assert File.exists?("web/templates/user")
  end

  test "creates controller files with --skip-template" do
    Mix.Tasks.Ashes.Generate.run(["controller", "photo", "--skip-template"])
    assert_file "web/controllers/photo_controller.ex"

    refute File.exists?("web/templates/photo")
  end

  test "creates a channel file" do
    Mix.Tasks.Ashes.Generate.run(["channel", "user"])
    assert_file "web/channels/user_channel.ex"
  end

  test "creates model file" do
    Mix.Tasks.Ashes.Generate.run(["model", "user"])
    assert_file "web/models/user.ex"
  end

end
