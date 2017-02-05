defmodule OneApi.Router do
  use OneApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OneApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", OneApi do
    pipe_through :api

    get "/rss", RssController, :index
    get "/rss/diycode", RssController, :diycode
    get "/rss/ifanr", RssController, :ifanr
    get "/rss/geekpark", RssController, :geekpark
    get "/rss/qdaily", RssController, :qdaily
  end

  # Other scopes may use custom stacks.
  # scope "/api", OneApi do
  #   pipe_through :api
  # end
end
