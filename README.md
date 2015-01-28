#Ashes

A code generation tool for the [Phoenix](http://www.phoenixwebframework.com) web framework.

```elixir
defp deps do
  [{:ashes, ">= 0.0.3"}]
end
```

###Controllers
Generates a controller with a given name, will also generate a view and create a folder
for you to put related .eex templates in. **Don't forget to add the controller in `routes.ex`**

```bash
$ mix ashes.generate controller <controllername>
```

```elixir
# web/router.ex
defmodule MyApp.Router do
  ...
  scope "/", MyApp do
    resources "/my", MyController
  end
end
```

Will give you the following functions by default:

* index
* edit
* new
* show
* create
* update
* delete

**Options**
* `--template or --controller-template` - path to a different ex file to use as your template
* `--filename or --controller-filename` - what to name your file, defaults to replacing the string `name` in the template filename
* `--view-template` - path to a custom ex view file
* `--view-filename` - filename to use for your view, defaults to replacing the string `name` in the template filename
* `--skip-form` - removes the `edit` and `new` functions from the controller (likely used for APIs)
* `--skip-view` - doesn't create a view module
* `--skip-template`- doesn't create a folder for templates

###Channels
Generates a channel with the given name. **Don't forget to add the channel to your router**

```bash
$ mix ashes.generate channel <channelname> [events]
```
```elixir
# routes.ex
defmodule MyApp.Router do
  ...
  socket "/ws", MyApp do
    channel "my:*", MyChannel
  end
end
```

Will give you the following functions by default:
* `join(_topic, message, socket)`
* `leave(_reason, socket)`

If you provide events in the generate command, they will be added to the channel as
```elixir
def handle_in("eventname", message, socket) do
  {:ok, socket}
end
```

**Options**
* `--template or --channel-template` - path to a different ex file to use as your template
* `--filename or --channel-filename` - what to name your file, defaults to replacing the string `name` in the template filename

###Models
Generates an [Ecto](https://github.com/elixir-lang/ecto) model with the given name and schema. **Requires ecto!**

```bash
$ mix ashes.generate model <modelname> [schema entries]
```

Schema entries should be of the form `name:type` with types being defined by ecto. 

**Options**
* `--timestamps` - adds ecto timestamps to your schema.
* `--template or --model-template` - path to a different ex file to use as your template
* `--filename or --channel-filename` - what to name your file, defaults to replacing the string `name` in the template file

###Migrations
**Assumes a valid repo module name of MyApp.Repo**

Generates an [Ecto](https://github.com/elixir-lang/ecto) migration with the given name. **Requires ecto**
```bash
$ mix ashes.generate migration <migrationname>
```

