defmodule BNO055.App.SensorSupervisor do
  use Supervisor

  def start_link(sensor) do
    id = String.to_atom(sensor.name <> "_sup")
    Supervisor.start_link(__MODULE__, [sensor: sensor, name: id], [id: id])
  end

  def init(opts) do
    sensor = Keyword.get(opts, :sensor)
    name = Keyword.get(opts, :name)

    sensor
    |> children
    |> supervise([strategy: :one_for_one, name: name])
  end

  defp children(sensor) do
    state_name = String.to_atom("bno055_" <> sensor.name <> "_state")
    driver_name = String.to_atom("bno055_" <> sensor.name <> "_driver")
    {comm_name, comm_mod} = load_comm_mod(sensor)

    [
      Supervisor.Spec.worker(
        BNO055.App.Sensor,
        [
          BNO055.App.Sensor.make_state(sensor, state_name, comm_name),
          [name: driver_name]
        ],
        [id: driver_name]
      )
    ] ++ comm_mod
  end

  @i2c_module Application.get_env(:bno055_modules, :i2c)
  @serial_module Application.get_env(:bno055_modules, :serial)
  defp load_comm_mod(%{comm_type: :i2c}=sensor) do
    config = sensor.comm_config

    comm_name = get_comm_name(sensor)
    mod = [
      Supervisor.spec.worker(
        @i2c_module,
        [
          config.channel,
          Map.get(config, :id, 0x28),
          [name: comm_name]
        ],
        [id: comm_name]
      )
    ]
  end
  defp load_comm_mod(%{comm_type: :serial}=sensor) do
    #TODO: Implement serial
    {nil, []}
  end
  defp get_comm_name(sensor), do: String.to_atom("bno055_" <> sensor.name <> "_comms")

end