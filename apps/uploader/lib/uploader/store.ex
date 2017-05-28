defmodule Uploader.Store do
  @moduledoc """
  Store for storing state temporarily
  """

  use GenServer

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get(atom) :: {:ok, term} | {:error, term}
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @spec set(atom, term) :: :ok
  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  def init(:ok) do
    :ets.new(:store, [:private, :named_table])
    {:ok, :ok}
  end

  def handle_call({:get, key}, _from, state) do
    case :ets.lookup(:store, key) do
      [{^key, value}] ->
        {:reply, {:ok, value}, state}
      [] ->
        {:reply, {:error, :not_found}, state}
    end
  end

  def handle_call({:set, key, value}, _from, state) do
    :ets.insert(:store, {key, value})
    {:reply, :ok, state}
  end
end
