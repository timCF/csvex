defmodule Csvex do
  use Application
  use Silverb, [{"@default_encoder_opts", %{separator: ";", str_separator: "\n", header: true}}]

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

  #
  # priv
  #
  defp get_req_keys(fields, opts) do
    case Map.get(opts, :keys) do
      nil -> fields
      keys when is_list(keys) -> true = Enum.all?(keys, &(Enum.member?(fields, &1))); keys
    end
  end

  defp list_is_uniform(lst, required_keys) do
  	Enum.all?(lst,
  		fn(el) ->
  			Enum.all?(required_keys, &(Map.has_key?(el, &1)))
  		end)
  end

  defp encode_proc(opts = %{separator: sep, header: true}, required_keys, lst), do: [encode_row(required_keys, sep)] |> encode_values(lst, required_keys, opts)
  defp encode_proc(opts = %{header: false}, required_keys, lst), do: encode_values([], lst, required_keys, opts)

  defp encode_values(reslst, [], _, %{str_separator: str_sep}), do: (Enum.reverse(reslst) |> Enum.join(str_sep))<>str_sep
  defp encode_values(reslst, [el|rest], required_keys, opts = %{separator: sep}), do: [Stream.map(required_keys, &(Map.get(el, &1))) |> encode_row(sep) | reslst] |> encode_values(rest, required_keys, opts)

  defp encode_row(row, sep), do: Stream.map(row, &(CSV.Encode.encode(&1, separator: sep))) |> Enum.join(sep)

  #
  # public
  #
  def encode(lst, opts \\ %{})
  def encode([], _), do: ""
  def encode([first|_] = lst, opts) when is_list(lst) do
    required_keys = Map.keys(first) |>  get_req_keys(opts)
    case list_is_uniform(lst, required_keys) do
      false -> raise "#{__MODULE__} got not uniform map(s) #{inspect lst}"
      true -> Map.merge(@default_encoder_opts, opts) |> encode_proc(required_keys, lst)
    end
  end

end
