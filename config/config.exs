# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :bno055_app, [
  names: %{
      supervisor: :bno055_app_sup
  },
  sensors: [
    %{
      name: "ch1",
      comm_type: :i2c,
      comm_config: %{
        channel: "i2c-1"
      },
      pub_sub_topic: "bno055_ch1",
    }
  ]
]

config :bno055_modules, [
  i2c: I2c,
  serial: Nerves.Uart
]
