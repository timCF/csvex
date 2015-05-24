defmodule Csvex do
  use Application
  use Silverb

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Csvex.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Csvex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp default_opt(:separator), do: ";"
  defp default_opt(:str_separator), do: "\n"
  
  def encode(lst, opts \\ %{})
  def encode([], _), do: ""
  def encode([first|_] = lst, opts) when is_list(lst) do
  	required_keys = case Map.get(opts, :keys) do
						nil -> 
							Map.keys(first)
						keys when is_list(keys) ->
							fields = Map.keys(first)
							true = Enum.all?(keys, &(Enum.member?(fields, &1)))
							keys
  					end
	case Enum.filter(lst, fn(el) -> 
							these_keys = Map.keys(el)
							not(required_keys |> Enum.all?(&(Enum.member?(these_keys, &1)))) 
						  end) do
		[] ->	Enum.reduce([:separator, :str_separator], opts, 
	  			fn(k, opts) ->
					case Map.get(opts, k) do
						nil -> Map.put(opts, k, default_opt(k))
						bin when is_binary(bin) -> opts
					end
	  			end) 
				|> encode_proc(required_keys, lst)
		err -> 	raise "#{__MODULE__} not uniform map(s) #{inspect err}"
	end
  end

  defp encode_proc(opts = %{separator: sep}, required_keys, lst) do 
	[Stream.map(required_keys, &(CSV.Encode.encode(&1, separator: sep))) |> Enum.join(sep)]
	|> encode_values(lst, required_keys, opts)
  end


  defp encode_values(reslst, [], _, %{str_separator: str_sep}), do: (Enum.reverse(reslst) |> Enum.join(str_sep))<>str_sep
  defp encode_values(reslst, [el|rest], required_keys, opts = %{separator: sep}) do
  	[Stream.map(required_keys, &(Map.get(el, &1) |> CSV.Encode.encode(separator: sep))) |> Enum.join(sep) |reslst]
  	|> encode_values(rest, required_keys, opts)
  end



end