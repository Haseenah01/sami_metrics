defmodule SamiMetricsWeb.Metrics do
  def count do
    :telemetry.execute([:metrics, :count], %{count: 1})
  end

end
