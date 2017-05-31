defmodule LoadTester.Application do
  @moduledoc """
  The LoadTester Application Service.

  The load_tester system business domain lives in this application.

  Exposes API to clients such as the `LoadTester.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      worker(LoadTester.Crawler.Manager, []),
      supervisor(LoadTester.Crawler.Supervisor, [])
    ], strategy: :one_for_one, name: LoadTester.Supervisor)
  end
end
