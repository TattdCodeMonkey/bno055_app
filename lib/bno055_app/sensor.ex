defmodule BNO055.App.Sensor do
  use GenServer
  require Logger

  @read_interval 50

  defmodule State do
    defstruct sensor_config: nil, state_name: nil, comm_name: nil, comm_type: nil, comm_pid: nil
  end

  def make_state(sensor, state_name, comm_name) do
    %State{
      sensor_config: sensor,
      state_name: state_name,
      comm_name: comm_name,
      comm_type: sensor.comm_type,
    }
  end

  def start_link(args, opts \\ []) do
    res = {:ok, pid} = GenServer.start_link(__MODULE__, args, opts)

    Process.send_after(pid, :initialize, @read_interval)

    res
  end

  def init(%State{} = args) do
    BNO055.App.SensorState.init(args.state_name)

    {:ok, args}
  end

  def handle_info(:initialize, state) do
    {:noreply, initialize(state)}
  end

  defp initialize(state) do
    case find_comms_pid(state) do
      {:not_found, _} ->
        Process.send_after(self, :initialize, @read_interval)
        state
      {:ok, state01} ->
        initialize_sensor(state01)
    end
  end
  defp intialize_sensor(state) do
    with {:ok, _} ->
  end

  defp find_comms_pid(%State{comm_name: nil}=state), do: state
  defp find_comms_pid(%State{comm_name: comm_name}=state) do
    case Process.whereis(comm_name) do
      nil -> {:not_found, state}
      pid -> {:ok, %State{state| comm_pid: pid}}
    end
  end

  defp wait_for_address(state) do
    result = BNO055.get_chip_address() |> read_from_sensor(state)
    case result do
      {:ok, data} ->
    end
  end

  defp write_cmd_to_sensor(_cmd, %State{comm_pid: nil}=state), do: state
  defp write_cmd_to_sensor(cmd, %State{comm_type: :i2c, comm_pid: pid}=state) do
  end
  defp write_cmd_to_sensor(cmd, %State{comm_type: :serial, comm_pid: pid}=state) do
  end

  defp read_from_sensor(_cmd, %State{comm_pid: nil}=state), do: state
  defp read_from_sensor(cmd, %State{comm_type: :i2c, comm_pid: pid}=state) do
  end
  defp read_from_sensor(cmd, %State{comm_type: :serial, comm_pid: pid}=state) do
  end
end