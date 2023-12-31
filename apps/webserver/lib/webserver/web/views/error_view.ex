defmodule Webserver.Web.ErrorView do
  use Webserver.Web, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("authentication_failed.json", _assigns) do
    %{errors: %{detail: "Authentication failed"}}
  end

  def render("parsing_failed.json", %{error: error}) do
    %{errors: %{detail: error}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
