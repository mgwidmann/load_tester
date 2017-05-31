defmodule LoadTester.Web.LoadTestingChannel do
  use LoadTester.Web, :channel

  def join(_, _, socket) do
    {:ok, socket}
  end
end
