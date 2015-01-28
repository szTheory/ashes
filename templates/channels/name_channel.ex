defmodule <%= application_name %>.<%= channel_name %>Channel do
  use Phoenix.Channel

  def join(_topic, message, socket) do
    {:ok, socket}
  end

  <%= for event <- events do %>
  def handle_in("<%= event %>", message, socket) do
    {:ok, socket}
  end
  <% end %>

  def leave(_reason, socket) do
    {:leave, socket}
  end
end
