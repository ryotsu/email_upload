defmodule Webserver.Web.MailgunView do
  use Webserver.Web, :view

  def render("status.json", %{status: status}) do
    %{data: %{status: status}}
  end
end
