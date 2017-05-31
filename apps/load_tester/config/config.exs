use Mix.Config

config :load_tester,
  number_of_nodes: 2

import_config "#{Mix.env}.exs"
