defmodule GrapgqlWeb.PageController do
  use GrapgqlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
