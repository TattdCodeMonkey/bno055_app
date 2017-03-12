defmodule BNO055.App.Supervisor do
  use Supervisor
  require Logger

  def start_link, do: Supervisor.start_link(__MODULE__, [], [])

  def init(_) do
    names = BNO055.App.Configuration.process_names

    Enum.map(BNO055.App.Configuration.sensors, &sensor_sup/1)
    |> supervise([strategy: :one_for_one, name: names.supervisor])
  end

  defp sensor_sup(sensor) do
    supervisor(BNO055.App.SensorSupervisor, [sensor])
  end
end