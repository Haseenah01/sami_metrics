defmodule SamiMetrics.Measurements do

  def time_measurements(measurements) do
    File.write("time_metrics.log","#{measurements}\n", [:append, {:delayed_write, 1000000, 20}])

  end
  #File.write("connections.log", "Total Connections: #{active + idle} | Active: #{active} | Idle: #{idle} \n", [:append, {:delayed_write, 1000000, 20}])

end
