defmodule BNO055.App do
  use Application
  @moduledoc """
  Documentation for BNO055.App.
  """


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

#    sensors = BNO055.Configuration.sensors
#    case BNO055.Configuration.validate_sensors(sensors) do
#      {:error, errs} ->
#        Logger.error("Errors found validating sensor(s) config: #{inspect sensors}")
#        Enum.map errs, fn err ->
#          Logger.error(err)
#        end
#        raise "Invalid sensor(s) configuration"
#      :ok -> :ok
#    end


    children = [
      supervisor(BNO055.App.Supervisor, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: __MODULE__])
  end
end
