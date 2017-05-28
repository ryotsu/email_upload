defmodule  Uploader.Queue do
  @moduledoc """
  Queue for storing upload requests
  """

  use GenStage

  alias Uploader.Store

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec push(term, integer) :: :ok
  def push(value, priority) do
    GenStage.cast(__MODULE__, {:push, value, priority})
  end

  @spec stop(atom) :: :ok
  def stop(reason \\ :normal) do
    GenServer.stop(__MODULE__, reason)
  end

  def init(:ok) do
    case Store.get(:queue) do
      {:ok, {queue, demand}} ->
        {:producer, {queue, demand}, dispatcher: GenStage.BroadcastDispatcher}
      {:error, _err} ->
        {:producer, {:pqueue2.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
    end
  end

  def handle_cast({:push, event, priority}, {queue, pending_demand}) do
    queue = :pqueue2.in(event, priority, queue)
    dispatch_events(queue, pending_demand, [])
  end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, pending_demand + incoming_demand, [])
  end

  def terminate(_reason, {queue, demand}) do
    Store.set(:queue, {queue, demand})
    :ok
  end

  defp dispatch_events(queue, 0, events) do
    {:noreply, Enum.reverse(events), {queue, 0}}
  end

  defp dispatch_events(queue, demand, events) do
    case :pqueue2.out(queue) do
      {{:value, event}, queue} ->
        dispatch_events(queue, demand - 1, [event | events])
      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
