defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
    Identicon is an Elixir app to generate identicons as a mapping from
    on a user name, a string.
  """

  @doc """
  """

  def main input do
    input
    |> hash_input
  end

  @doc """
    md5 hashes the username and return
    the result as a binary representaiton, only as
    a list.
  """
  def hash_input input do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
