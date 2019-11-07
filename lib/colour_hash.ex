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
      "186CE0"
      iex> ColourHash.hex("test", %{lightness: [0.1], saturation: [0.1, 0.9], hue_range: %{min: 30, max: 30} } )
      "18171C"


  """
  def hex(string, options \\ %{lightness: @default_lightnes, saturation: @default_saturation, hue_range: @default_hue_range } ) do
    string
    |> hash_to_integer
    |> hsl_calc(%{l: options.lightness, s: options.saturation})
    |> hsl_to_rgb
    |> Enum.map(&Integer.to_string(&1,16))
    |> Enum.join()
    |> String.pad_leading(6,"0")
  end

  @doc """
      String hashed to colour rgb tuple string
      iex> ColourHash.rgb("test")
      {24, 108, 224}
      iex> ColourHash.rgb("test", %{lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 50, max: 330} } )
      {24, 18, 33}
      
  """
  def rgb(string, options \\ %{lightness: @default_lightnes, saturation: @default_saturation, hue_range: @default_hue_range } ) do
    [r,g,b] = string
    |> hash_to_integer
    |> hsl_calc(%{l: options.lightness, s: options.saturation})
    |> hsl_to_rgb    
    {r,g,b}
  end

  @doc """
  String hashed to colour hsl tuple string
  iex> ColourHash.hsl("test")
  {274, 0.65, 0.65}
  iex> ColourHash.hsl("test", %{lightness: [0.1], saturation: [0.3, 0.9], hue_range: %{min: 50, max: 330} } )
  {274, 0.3, 0.1}
  """
  def hsl(string, options \\ %{lightness: @default_lightnes, saturation: @default_saturation, hue_range: @default_hue_range } ) do
    string
    |> hash_to_integer
    |> hsl_calc(%{l: options.lightness, s: options.saturation})
  end

  defp hash_to_integer(str) do
    <<hash::224>> = :crypto.hash(:sha224,str);
    hash
  end

  defp hsl_calc(value, options) do    
    h = rem(value, 359)    
    value = floor(value / 360)
    s_length = Enum.count(options.s)
    l_length = Enum.count(options.l)
    value = floor(value / s_length) 
    s = Enum.at(options.s, rem(value, s_length))
    value = floor(value / l_length)
    l = Enum.at(options.l, rem(value, l_length))
    {h,s,l}
  end

  defp hsl_to_rgb {h, s, l} do 
    
    h = h / 360
    q = if l < 0.5, do: l * (1 + s), else: l + s - (l * s)
    p = 2 * l - q

    [h + (1/3), h , h - (1/3)]
    |> Enum.map(fn 
      (color) ->
        cond do 
          color < 0     -> (color + 1 )  
          color > 1     -> (color - 1)  
          color < (1/6) -> (p + (q - p) * 6 * color)  
          color < 0.5   -> q
          color < (2/3) -> (p + (q - p) * 6 * (2/3 - color))
          true -> p
        end
        |> Kernel.*(255)
        |> round
    end)
  end


end
