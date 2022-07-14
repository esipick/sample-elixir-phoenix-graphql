defmodule GraphqlReactWeb.PageController do
  use GraphqlReactWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  def home(conn, _params) do
    render(conn, "home.html")
  end

  def settings(conn, _params) do
    render(conn, "settings.html")
  end

  def email_verification(conn, _params) do
    render(conn, "email_verification.html")
  end
  def secondary_email_verification(conn, _params) do
    render(conn, "secondary_email_verification.html")
  end
end
