defmodule Uploader.WorkerPool do
  @moduledoc """
  Consumer for genstage, downloading and uploading files
  """

  use ConsumerSupervisor

  alias Uploader.Queue

  def start_link do
    children = [
      supervisor(Uploader.File.Supervisor, [], restart: :temporary)
    ]

    ConsumerSupervisor.start_link(children, name: __MODULE__,
      strategy: :one_for_one, subscribe_to: [{Queue, max_demand: 10}]
    )
  end

  def init(:ok) do
    {:consumer, :ok}
  end
end
