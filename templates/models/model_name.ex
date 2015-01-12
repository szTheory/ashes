defmodule <%= application_name %>.<%= model_name %> do
  use Ecto.Model
  <%= if options[:timestamps] do %>
  before_insert <%= model_name %>, :add_timestamps
  def add_timestamps(user) do
    now = Ecto.DateTime.utc
    user
    |> put_change(:updated_at, now)
    |> put_change(:created_at, now)
  end

  before_update <%= model_name %>, :bump_updated_at
  def bump_updated_at(user) do
    now = Ecto.DateTime.utc
    put_change(:updated_at, now)
  end
  <% end %>

  schema "<%= model_plural %>" do
    <%= for line <- schema do %>
    field <%= Enum.map_join(String.split(line,":"), ", ", &(":#{&1}")) %>
    <% end %>
    <%= if options[:timestamps] do %>
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    <% end %>
  end
end
