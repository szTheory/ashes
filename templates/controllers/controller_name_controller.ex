defmodule <%= application_name %>.<%= controller_name %> do
  use Phoenix.Controller

  use :plug

  # GET /<%= controller %>
  def index(conn, _params) do
  end

  <%= if !options[:skip_forms] do %>
  # GET /<%= controller %>/:id/edit
  def edit(conn, _params) do
  end

  # GET /<%= controller %>/new
  def new(conn, _params) do
  end
  <% end %>

  # GET /<%= controller %>/:id
  def show(conn, _params) do
  end

  # POST /<%= controller %>
  def create(conn, _params) do
  end

  # PUT /<%= controller %>/:id
  def update(conn, _params) do
  end

  # DELETE /<%= controller %>/:id
  def delete(conn, _params) do
  end
end
