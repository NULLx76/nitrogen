defmodule NitrogenWeb.Component.GraphGrid do
  use Surface.Component
  alias NitrogenWeb.Component

  prop notebooks, :list, required: true

  # calculate_grid calculates the amount of columns and rows needed to fit N elements (somewhat) equally
  defp calculate_grid(list) when is_list(list), do: calculate_grid(length(list))

  defp calculate_grid(n) when is_integer(n) do
    cols = ceil(:math.sqrt(n))
    rows = ceil(n / cols)
    "grid-template-columns: repeat(#{cols},minmax(0,1fr)); grid-template-rows: repeat(#{rows},minmax(0,1fr))"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid w-full h-full" style={{calculate_grid(@notebooks)}}>
      <div class="border border-4 text-center relative" :for={{ notebook <- @notebooks }}>
        <h3 class="text-black text-2xl">{{ notebook.name }}</h3>
        <Component.Graph id="g{{notebook.id}}" notebook={{notebook}} />
      </div>
    </div>
    """
  end
end
