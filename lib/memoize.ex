defmodule Memoize do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [worker(Memoize.Cache, []),
               ]

    opts = [strategy: :one_for_one, name: Memoize.Supervisor]
    Supervisor.start_link(children, opts)
  end


  defmacro defmemoize(name_params, do: block) do
    {name, _, params} = name_params
     quote do
      def unquote(name)(unquote_splicing(params)) do
        case Memoize.Cache.lookup({unquote(name), unquote(params)}) do
          {:error, :not_found} ->
            value = unquote(block)
            Memoize.Cache.insert({unquote(name), unquote(params)}, value)
            value
          value ->
            value
        end
      end
    end
  end

end
