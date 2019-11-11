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
      "9EBF40"
      iex> ColourHash.hex("test", lightness: [0.1], saturation: [0.1, 0.9], hue_range: %{min: 30, max: 30} )
      "1C1A17"


  """
  def hex(string, options \\ []) do
    string
    |> hash_to_integer
    |> hsl_calc(options)
    |> hsl_to_rgb
    |> Enum.map(&Integer.to_string(&1, 16))
    |> Enum.join()
    |> String.pad_leading(6, "0")
  end

  @doc """
      String hashed to colour rgb tuple string
      iex> ColourHash.rgb("test")
      {158, 191, 64}
      iex> ColourHash.rgb("test", lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 50, max: 330} )
      {21, 33, 18}
      
  """
  def rgb(string, options \\ []) do
    [r, g, b] =
      string
      |> hash_to_integer
      |> hsl_calc(options)
      |> hsl_to_rgb

    {r, g, b}
  end

  @doc """
  String hashed to colour hsl tuple string
  iex> ColourHash.hsl("test")
  {75.76341127922971, 0.5, 0.5}
  iex> ColourHash.hsl("test", lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 150, max: 330} )
  {187.88170563961486, 0.3, 0.1}
  """
  def hsl(string, options \\ []) do
    string
    |> hash_to_integer
    |> hsl_calc(options)
  end

  @max_safe_integer 65_745_979_961_613
  @seed 131
  @seed2 137

  defp hash_to_integer(str) do
    (str <> "x")
    |> String.to_charlist()
    |> Enum.reduce(0, fn
      a, hash when hash < @max_safe_integer -> hash * @seed + a
      a, hash -> floor(hash / @seed2) * @seed + a
    end)
  end

  defp hsl_calc(value, options) do
    hue_range = Keyword.get(options, :hue_range, @default_hue_range)
    saturation = Keyword.get(options, :saturation, @default_saturation)
    lightness = Keyword.get(options, :lightness, @default_lightnes)

    h = rem(value, 727) * (hue_range.max - hue_range.min) / 727 + hue_range.min

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
    h = h / 360

    m2 =
      if l <= 0.5,
        do: l * (s + 1),
        else: l + s - l * s

    m1 = l * 2 - m2
    r = hue_to_rgb(m1, m2, h + 1 / 3)
    g = hue_to_rgb(m1, m2, h)
    b = hue_to_rgb(m1, m2, h - 1 / 3)
    [round(r * 255), round(g * 255), round(b * 255)]
  end

  defp hue_to_rgb(m1, m2, h) do
    h = if h < 0, do: h + 1, else: h
    h = if h > 1, do: h - 1, else: h

    case h do
      h when h * 6 < 1 -> m1 + (m2 - m1) * h * 6
      h when h * 2 < 1 -> m2
      h when h * 3 < 2 -> m1 + (m2 - m1) * (2 / 3 - h) * 6
      _ -> m1
    end
  end
end
