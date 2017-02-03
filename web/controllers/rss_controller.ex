defmodule OneApi.RssController do
  use OneApi.Web, :controller

  def ifanr(conn, _params) do
    case OneApi.Ifanr.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def geekpark(conn, _params) do
    case OneApi.GeekPark.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def qdaily(conn, _params) do
    case OneApi.QDaily.fetch do
      {:ok, response} ->
        json(conn, response)
      {:error, reason} ->
        json(conn, reason)
    end
  end
end
