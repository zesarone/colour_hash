# ColourHash
 
  A port of https://github.com/zenozeng/color-hash

  hash a string into a colour hex string.
  set hue, lighting and saturation to keep colours matching.

  ## Examples
      
      iex> ColourHash.hex("test")
      "186CE0"
      iex> ColourHash.rgb("test")
      {24, 108, 224}
      iex> ColourHash.hsl("test")
      {274, 0.65, 0.65}
      iex> ColourHash.hex("test", %{lightness: [0.1], saturation: [0.1, 0.9], hue_range: %{min: 30, max: 30} } )
      "18171C"

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `colour_hash` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:colour_hash, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/colour_hash](https://hexdocs.pm/colour_hash).

