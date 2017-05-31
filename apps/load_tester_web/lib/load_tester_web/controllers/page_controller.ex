defmodule LoadTester.Web.PageController do
  use LoadTester.Web, :controller

  def index(conn, _params) do
    LoadTester.Crawler.shutdown()
    render conn, "index.html"
  end

  def start(conn, %{"requests" => requests, "url" => url}) do
    {requests, _} = Integer.parse(requests)
    Logger.info "Starting workers for #{inspect requests} per minute at #{inspect url}"
    LoadTester.Crawler.startup(requests, url)
    send_resp(conn, :ok, "")
  end

  def stop(conn, _params) do
    LoadTester.Crawler.shutdown()
    send_resp(conn, :ok, "")
  end
end
