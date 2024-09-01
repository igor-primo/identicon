defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
    Identicon is an Elixir app to generate identicons as a mapping from
    on a user name, a string.
  """
  alias Identicon.Image

  @doc """
    Main entry point to the program.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Saves the image.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
    Draws the image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
    Builds the pixel map.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Filters grid so that we have only the even ones.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Builds the grid that stores the number of each Identicon block
    and its index.
  """
  def build_grid(%Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Mirrors rows.
  """
  def mirror_row([fst, snd | _tail] = row) do
    row ++ [snd, fst]
  end

  @doc """
    Picks the first 3 numbers from the list of representation
    of the md5 binary hash. These are the RGB.
  """
  def pick_color(%Image{hex: [r, g, b | _tail]} = image) do
    # Is not pattern matching and equational reasoning lovely, delicious?
    %Image{image | color: {r, g, b}}
  end

  @doc """
    md5 hashes the username and return
    the result as a binary representaiton, only as
    a list.
  """
  def hash_input(input) do
    %Identicon.Image{hex: :crypto.hash(:md5, input) |> :binary.bin_to_list()}
  end
end
