defmodule Memoize.Cache do

  use GenServer

  def insert(key = {_, _}, val) do
    GenServer.call(__MODULE__, {:insert, key, val})
  end

  def lookup(key = {_, _}) do
    case :ets.lookup(__MODULE__, key) do
      [] -> {:error, :not_found}
      [{key, value} | _] -> value
    end
  end

  # Behaviour/OTP callbacks

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init([]) do
    table = :ets.new(__MODULE__, [:set, :protected, :named_table, {:read_concurrency, true}])
    {:ok, table}
  end

  def handle_call({:insert, key, value}, from, state) do
    true = :ets.insert(__MODULE__, {key, value})
    {:reply, :ok, state}
  end

  def terminate(:normal, _), do: :ok
end

