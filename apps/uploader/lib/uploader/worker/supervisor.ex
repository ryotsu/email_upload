defmodule Uploader.File.Supervisor do
  @moduledoc """
  Supervisor for file processes
  """

  use Supervisor

  def start_link(mail) do
    Supervisor.start_link(__MODULE__, mail)
  end

  def init(mail) do
    children = [
      worker(Uploader.File.Manager, [self(), mail])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def add_child(pid, attachment, token, counter) do
    file_worker = worker(Uploader.File.Worker, [attachment, token, counter],
      id: attachment, restart: :transient)

    Supervisor.start_child(pid, file_worker)
  end
end
