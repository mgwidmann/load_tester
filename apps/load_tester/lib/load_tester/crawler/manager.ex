defmodule LoadTester.Crawler.Manager do
  use GenServer
  require Logger
  alias Phoenix.PubSub

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    PubSub.subscribe(LoadTester.Web.PubSub, "load_test:control")
    {:ok, nil}
  end

  def handle_info({:startup, %{url: url, requests: requests}}, _) do
    for _ <- 1..requests do
      Supervisor.start_child(LoadTester.Crawler.Supervisor, [url])
    end
    {:noreply, nil}
  end

  def handle_info(:shutdown, _) do
    for {_, pid, _, [LoadTester.Crawler]} <- Supervisor.which_children(LoadTester.Crawler.Supervisor) do
      if Process.alive?(pid) do
        Logger.debug "Waiting for #{inspect pid} to finish up..."
        Supervisor.terminate_child(LoadTester.Crawler.Supervisor, pid)
      end
    end
    {:noreply, nil}
  end



end
