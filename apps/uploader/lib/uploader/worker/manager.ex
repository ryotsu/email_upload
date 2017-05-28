defmodule Uploader.File.Manager do
  @moduledoc """
  Keep a count of workers and stop supervisor when workers finish
  """

  use GenServer

  def start_link(sup_pid, mail) do
    GenServer.start_link(__MODULE__, [sup_pid, mail])
  end

  def add_child(pid) do
    GenServer.cast(pid, :add)
  end

  def remove_child(pid) do
    GenServer.cast(pid, :remove)
  end

  def init([sup_pid, mail]) do
    send(self(), {:start, mail})
    {:ok, {sup_pid, 0}}
  end

  def handle_cast(:add, {sup_pid, children}) do
    {:noreply, {sup_pid, children + 1}}
  end

  def handle_cast(:remove, {sup_pid, 1}) do
    Supervisor.stop(sup_pid)
    {:noreply, {sup_pid, 0}}
  end

  def handle_cast(:remove, {sup_pid, children}) do
    {:noreply, {sup_pid, children - 1}}
  end

  def handle_info({:start, mail}, {sup_pid, children}) when is_map(mail) do
    Enum.each(mail.attachments, fn attachment ->
      Uploader.File.Supervisor.add_child(
        sup_pid, attachment, mail.token, self())
    end)

    {:noreply, {sup_pid, children}}
  end

  def handle_info({:start, _}, state) do
    {:noreply, state}
  end
end
