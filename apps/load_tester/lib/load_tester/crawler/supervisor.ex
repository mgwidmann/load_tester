defmodule LoadTester.Crawler.Supervisor do

  def start_link() do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      worker(LoadTester.Crawler, [])
    ], strategy: :simple_one_for_one, name: LoadTester.Crawler.Supervisor)
  end
end
