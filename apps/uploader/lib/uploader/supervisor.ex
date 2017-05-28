defmodule Uploader.Supervisor do
  @moduledoc """
  Top level supervisor for uploader
  """

  use Supervisor

  alias Uploader.Queue
  alias Uploader.Store
  alias Uploader.WorkerPool

  @spec start_link() :: {:ok, pid}
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Store, []),
      worker(Queue, []),
      supervisor(WorkerPool, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
