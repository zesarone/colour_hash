defmodule ColourHash do
  @moduledoc """
  Documentation for ColourHash.
  """

  @default_lightnes [0.35, 0.5, 0.65]
  @default_saturation [0.35, 0.5, 0.65]
  @default_hue_range %{min: 0, max: 360}

  @doc """
  String hashed to colour hex string

  ## Examples
      
      iex> ColourHash.hex("test")
      "A46CE0"
      iex> ColourHash.hex("test", lightness: [0.1], saturation: [0.1, 0.9], hue_range: %{min: 30, max: 30} )
      "1C1A17"
  """
  def hex(string, options \\ []) do
    string
    |> rgb(options)
    |> rgb_to_hex
  end

  @doc """
      String hashed to colour rgb tuple string
      iex> ColourHash.rgb("test")
      {164, 108, 224}
      iex> ColourHash.rgb("test", lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 50, max: 330} )
      {23, 18, 33}
  """
  def rgb(string, options \\ []) do
    string
    |> hsl(options)
    |> hsl_to_rgb
  end

  @doc """
      String hashed to colour hsl tuple string
      iex> ColourHash.hsl("test")
      {268.88583218707015, 0.65, 0.65}
      iex> ColourHash.hsl("test", lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 150, max: 330} )
      {284.4429160935351, 0.3, 0.1}
  """
  def hsl(string, options \\ []) do
    string
    |> hash_to_integer
    |> hsl_calc(options)
  end

  defp hash_to_integer(str) do
    <<hash::224>> = :crypto.hash(:sha224, str)
    hash
  end

  defp hsl_calc(value, options) do
    hue_range = Keyword.get(options, :hue_range, @default_hue_range)
    saturation = Keyword.get(options, :saturation, @default_saturation)
    lightness = Keyword.get(options, :lightness, @default_lightnes)
    arc = Map.get(hue_range, :max, 360) - Map.get(hue_range, :min, 0)

    h = rem(value, 727) * arc / 727 + Map.get(hue_range, :min, 0)

    value = floor(value / 360)
    s_length = Enum.count(saturation)
    l_length = Enum.count(lightness)
    value = floor(value / s_length)
    s = Enum.at(saturation, rem(value, s_length))
    value = floor(value / l_length)
    l = Enum.at(lightness, rem(value, l_length))
    {h, s, l}
  end

  defp hsl_to_rgb({h, s, l}) do
    m2 =
      if l <= 0.5,
        do: l * (s + 1),
        else: l + s - l * s

    m1 = l * 2 - m2

    h = h / 360

    [r, g, b] =
      [1 / 3, 0, -1 / 3]
      |> Enum.map(fn hue_part ->
        hue_to_rgb(m1, m2, h + hue_part) |> Kernel.*(255) |> round()
      end)

    {r, g, b}
  end

  defp hue_to_rgb(m1, m2, h) when h < 0, do: hue_to_rgb(m1, m2, h + 1)
  defp hue_to_rgb(m1, m2, h) when h > 1, do: hue_to_rgb(m1, m2, h - 1)
  defp hue_to_rgb(m1, m2, h) when h * 6 < 1, do: m1 + (m2 - m1) * h * 6
  defp hue_to_rgb(_m1, m2, h) when h * 2 < 1, do: m2
  defp hue_to_rgb(m1, m2, h) when h * 3 < 2, do: m1 + (m2 - m1) * (2 / 3 - h) * 6
  defp hue_to_rgb(m1, _m2, _h), do: m1

  defp rgb_to_hex({r, g, b}) do
    [r, g, b]
    |> Enum.map(&(Integer.to_string(&1, 16) |> String.pad_leading(2, "0")))
    |> Enum.join()
  end
end
