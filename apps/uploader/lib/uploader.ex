defmodule Uploader do
  @moduledoc """
  Documentation for Uploader.
  """

  use Application

  def start(_type, _args) do
    Uploader.Supervisor.start_link()
  end
end
