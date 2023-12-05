defmodule SamiMetrics.Repo do
  use Ecto.Repo,
    otp_app: :sami_metrics,
    adapter: Ecto.Adapters.Postgres
end
