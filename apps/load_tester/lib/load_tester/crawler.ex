defmodule LoadTester.Crawler do
  use GenServer
  alias Phoenix.PubSub
  require Logger

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    # PubSub.subscribe(LoadTester.Web.PubSub, "load_test")
    # PubSub.subscribe(LoadTester.Web.PubSub, "load_test:stop")
    Logger.debug "Starting a working against #{inspect url}"
    Process.send_after(self, :crawl, 0)
    {:ok, %{url: url}}
  end

  @one_minute 1_000 * 60
  def handle_info(:crawl, %{url: url} = state) do
    Task.start fn ->
      request_time = round(:rand.uniform() * 500 + 500)
      # Sleep a random amount of time to simulate a request happening...
      Process.sleep(request_time)
      PubSub.broadcast(LoadTester.Web.PubSub, "load_test:data", message(request_time, url))
    end

    # Set up next request
    Process.send_after(self, :crawl, @one_minute)
    {:noreply, state}
  end

  defp message(request_time, url) do
    %{__struct__: Phoenix.Socket.Broadcast, event: "report", topic: "load_test:data", payload: %{url: url, time: request_time, result: Enum.random([:success, :failure])}}
  end

  def startup(requests, url) do
    shutdown()
    number_of_nodes = Application.get_env(:load_tester, :number_of_nodes, 1)
    requests_per_node = div(requests, number_of_nodes)
    PubSub.broadcast(LoadTester.Web.PubSub, "load_test:control", {:startup, %{url: url, requests: requests_per_node}})
  end

  def shutdown() do
    PubSub.broadcast(LoadTester.Web.PubSub, "load_test:control", :shutdown)
  end
end
