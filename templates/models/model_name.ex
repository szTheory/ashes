defmodule <%= application_name %>.<%= model_name %> do
  use Ecto.Model
  schema "<%= model_plural %>" do
    <%= for line <- schema do %>
    field <%= Enum.map_join(String.split(line,":"), ", ", &(":#{&1}")) %>
    <% end %>
    <%= if options[:timestamps] do %>
    timestamps
    <% end %>
  end
end
