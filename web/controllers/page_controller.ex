defmodule OneApi.PageController do
  use OneApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
