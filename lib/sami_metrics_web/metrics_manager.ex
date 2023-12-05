defmodule SamiMetricsWeb.MetricsManager do
  use Agent

  def start_link do
    Agent.start_link(&initial_state/0, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, &(&1))
  end

  def increment(metric_name, _value \\ 1, count \\ 1) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, metric_name, count, &(&1 + count))
    end)
  end

  defp initial_state do
    %{}
  end
end
