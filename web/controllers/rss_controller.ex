defmodule OneApi.RssController do
  use OneApi.Web, :controller

  import Pit

  def index(conn, params) do
    ifanr = OneApi.Rss.Ifanr.fetch
    geekpark = OneApi.Rss.GeekPark.fetch
    qdaily = OneApi.Rss.QDaily.fetch

    response = ifanr
    |> pit([ifanr_response, geekpark] <- {:ok, ifanr_response})
    |> pit([ifanr_response, geekpark_response, qdaily] <- [ifanr_response, {:ok, geekpark_response}])
    |> pit([ifanr_response, geekpark_response, qdaily_response] <- [ifanr_response, geekpark_response, {:ok, qdaily_response}])
    |> List.flatten
    json(conn, response)
  end

  def ifanr(conn, _params) do
    case OneApi.Rss.Ifanr.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def geekpark(conn, _params) do
    case OneApi.Rss.GeekPark.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def qdaily(conn, _params) do
    case OneApi.Rss.QDaily.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def diycode(conn, params) do
    case OneApi.Rss.DiyCode.fetch(params) do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end
end
