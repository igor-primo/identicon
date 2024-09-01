defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
    Identicon is an Elixir app to generate identicons as a mapping from
    on a user name, a string.
  """
  alias Identicon.Image

  @doc """
  """

  def main input do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid %Image{hex: hex} do
    hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
  end

  def mirror_row [fst, snd | _tail] = row do
    row ++ [snd, fst]
  end

  @doc """
    Picks the first 3 numbers from the list of representation
    of the md5 binary hash. These are the RGB.
  """
  def pick_color %Image{hex: [r, g, b | _tail ]} = image do
    # Is not pattern matching and equational reasoning lovely, delicious?
    %Image{image | color: {r, g, b}}
  end

  @doc """
    md5 hashes the username and return
    the result as a binary representaiton, only as
    a list.
  """
  def hash_input input do
    %Identicon.Image{hex: :crypto.hash(:md5, input) |> :binary.bin_to_list}
  end
end
