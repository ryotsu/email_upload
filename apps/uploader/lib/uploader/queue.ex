defmodule  Uploader.Queue do
  @moduledoc """
  Queue for storing upload requests
  """

  use GenServer

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec push(term, integer) :: :ok
  def push(value, priority) do
    GenServer.cast(__MODULE__, {:push, value, priority})
  end

  @spec pop(integer) :: [term]
  def pop(count \\ 1) do
    GenServer.call(__MODULE__, {:pop, count})
  end

  @spec stop() :: :ok
  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  def init(:ok) do
    {:ok, :pqueue.new}
  end

  def handle_cast({:push, value, priority}, queue) do
    new_queue = :pqueue.in(value, priority, queue)
    {:noreply, new_queue}
  end

  def handle_call({:pop, count}, _from, queue) do
    {values, new_queue} = get_items(queue, count)
    {:reply, values |> Enum.reverse, new_queue}
  end

  def handle_call(:stop, _from, queue) do
    {:stop, :normal, queue}
  end

  def terminate(_reason, _queue) do
    :ok
  end

  @spec get_items(term, integer, [term]) :: {[term], term}
  defp get_items(queue, count, values \\ [])

  defp get_items(queue, 0, values) do
    {values, queue}
  end

  defp get_items(queue, count, values) do
    case :pqueue.out(queue) do
      {{:value, value}, new_queue} ->
        get_items(new_queue, count - 1, [value | values])
      {:empty, new_queue} ->
        {values, new_queue}
    end
  end
end
