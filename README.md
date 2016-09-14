# Memoize

Memoize is a library which caches a function calls parameters and the resulting value
to retrieve them from the cache on succeeding calls with the same function parameters.

This happens opaque to the programmer (just use `defmemoize` keyword insted of `def`).


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `memoize` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:memoize, "~> 0.1.0"}]
    end
    ```

  2. Ensure `memoize` is started before your application:

    ```elixir
    def application do
      [applications: [:memoize]]
    end
    ```


## Usage

Define memoized functions by using the `defmemoize` macro.

Very simple usage example:
```elixir
  defmodule TestModule do

    import Memoize

    defmemoize testfun(a, b), do: a + b

  end
  2 = testfun(1, 1) # regular execution of function body
  2 = testfun(1, 1) # result value retrieved from cache, function body not executed
```

## Documentation

If [published on HexDocs](https://hex.pm/docs/tasks#hex_docs), the docs can
be found at [https://hexdocs.pm/memoize](https://hexdocs.pm/memoize)

