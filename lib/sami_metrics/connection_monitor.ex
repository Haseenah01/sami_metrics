defmodule SamiMetrics.ConnectionMonitor do
# #   # use GenServer

# #   # def start_link(_) do
# #   #   GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
# #   # end

# #   # def init(:ok) do
# #   #   {:ok, %{"total" => 0, "in_queue" => 0, "busy" => 0}}
# #   # end

# #   # def handle_info({:connection_status, total, in_queue, busy}, state) do
# #   #   new_state = %{
# #   #     "total" => total,
# #   #     "in_queue" => in_queue,
# #   #     "busy" => busy
# #   #   }

# #   #   IO.inspect(new_state, label: "Connection Status")
# #   #   {:noreply, new_state}
# #   # end

# #   # def track_connection_status(pid) do
# #   #   {:ok, pool} = Ecto.Adapters.get_pool(SamiMetrics.Repo)

# #   #   total = :erlang.system_info(:scheduler_threads)
# #   #   in_queue = length(pool.queue)
# #   #   busy = pool.busy_size

# #   #   GenServer.cast(__MODULE__, {:connection_status, total, in_queue, busy})
# #   # end

# #   use GenServer

# #   def start_link(_) do
# #     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
# #   end

# #   def init(:ok) do
# #     {:ok, %{"total" => 0, "in_queue" => 0, "busy" => 0}}
# #   end

# #   def handle_info({:ecto, :checkout, time, _pid, _reason, _stacktrace}, state) do
# #     IO.inspect("Ecto Checkout Event", label: "Telemetry Event")
# #     # Handle checkout event, update state or log metrics as needed
# #     {:noreply, state}
# #   end

# #   def handle_info({:ecto, :checkin, time, _pid}, state) do
# #     IO.inspect("Ecto Checkin Event", label: "Telemetry Event")
# #     # Handle checkin event, update state or log metrics as needed
# #     {:noreply, state}
# #   end

# #   def handle_event(_event_name, _event_type, _time, state) do
# #     IO.inspect("Telemetry Event", label: "Telemetry Event")
# #     {:noreply, state}
# #   end
# # end
# defmodule SamiMetrics.ConnectionMonitor do
#   use GenServer

#   def start_link(_) do
#     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
#   end

#   def init(:ok) do
#     {:ok, %{"total" => 0, "in_queue" => 0, "busy" => 0}}
#   end

#   def handle_info({:ecto, :checkout, time, pid, _reason, _stacktrace}, state) do
#     handle_event(:ecto, :checkout, time, pid, state)
#   end

#   def handle_info({:ecto, :checkin, time, pid}, state) do
#     handle_event(:ecto, :checkin, time, pid, state)
#   end

#   def handle_event(_event_name, _event_type, _time, _pid, state) do
#     # You can add logic here to process telemetry events and update state accordingly
#     IO.inspect("Telemetry Event", label: "Telemetry Event")
#     {:noreply, state}
#   end

#   # Example handling of pool metrics
#   def handle_event(:ecto, :checkout, pid, state) do
#     pool_info = get_pool_info(pid)
#     new_state = update_state(pool_info, state)
#     IO.inspect(new_state, label: "Connection Status")
#     {:noreply, new_state}
#   end

#   def handle_event(:ecto, :checkin, pid, state) do
#     pool_info = get_pool_info(pid)
#     new_state = update_state(pool_info, state)
#     IO.inspect(new_state, label: "Connection Status")
#     {:noreply, new_state}
#   end

#   defp get_pool_info(pid) do
#     {:ok, pool} = Ecto.Adapters.SQL.Sandbox.checkout(SamiMetrics.Repo)
#     {:ok, pool_info} = :telemetry.execute([:ecto, :checkout], %{pid: pool.pid})
#     pool_info
#   end

#   defp update_state(pool_info, state) do
#     total = Map.get(pool_info, :pool_size, 0)
#     in_queue = Map.get(pool_info, :queue_size, 0)
#     busy = Map.get(pool_info, :busy_size, 0)

#     %{
#       "total" => total,
#       "in_queue" => in_queue,
#       "busy" => busy
#     }
#   end
 end
