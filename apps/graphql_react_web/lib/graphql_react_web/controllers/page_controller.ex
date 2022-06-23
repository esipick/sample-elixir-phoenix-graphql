defmodule GraphqlReactWeb.PageController do
  use GraphqlReactWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
