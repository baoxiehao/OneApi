defmodule OneApi.RssController do
  use OneApi.Web, :controller

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

  def goldxitu(conn, _params) do
    case OneApi.Rss.GoldXitu.fetch do
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
