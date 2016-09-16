defmodule Memoize.Cache do

  use GenServer

  def insert(key = {_, _, _}, val) do
    GenServer.call(__MODULE__, {:insert, key, val})
  end

  def lookup(key = {_, _, _}) do
    case :ets.lookup(__MODULE__, key) do
      [] -> {:error, :not_found}
      [{^key, value} | _] -> value
    end
  end

  def invalidate(key_spec) do
    GenServer.call(__MODULE__, {:invalidate, key_spec})
  end

  @doc """
  Helper function to inspect the number of current cache entries.
  """
  def count do
    :ets.select_count Memoize.Cache, [{:_, [], [true]}]
  end

  # Behaviour/OTP callbacks

  def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init([]) do
    table = :ets.new(__MODULE__, [:set, :protected, :named_table, {:read_concurrency, true}])
    {:ok, table}
  end

  def handle_call({:insert, key, value}, _from, state) do
    true = :ets.insert(__MODULE__, {key, value})
    {:reply, :ok, state}
  end

  def handle_call({:invalidate, key_spec}, _from, state) do
    reply = :ets.match_delete(__MODULE__, {key_spec, :_})
    {:reply, reply, state}
  end

  def terminate(:normal, _), do: :ok
end

