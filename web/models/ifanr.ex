defmodule OneApi.Ifanr do
  use HTTPoison.Base

  @domain "http://www.ifanr.com"

  def process_url(url) do
    @domain
  end

  def process_response_body(html) do
    Floki.find(html, "div..article-item.article-item--card")
    |> Enum.map(&OneApi.Ifanr.parse/1)
  end

  """
  <div class="article-item article-item--card " data-post-id="782014">
    <div class="article-image cover-image" style="background-image: url('http://ifanr-cdn.b0.upaiyun.com/wp-content/uploads/2016/05/cook.jpg!260');"></div>
    <a href="http://www.ifanr.com/category/business" class="article-label" target="_blank">公司</a>
    <a href="http://www.ifanr.com/782014" class="article-link cover-block" target="_blank"></a>
    <h3>因节假日 iPhone 卖得好，苹果新一季财报成绩喜人，但大中华区就&#8230;&#8230;</h3>
    <time>前天 16:50</time>
    <div class="article-meta" data-post-id="782014">
      <span class="ifanrx-like like-count js-article-like-count">-</span>
      <a class="text-link" href="http://www.ifanr.com/782014#article-comments" target="_blank"><span class="ifanrx-reply comment-count">-</span></a>
    </div>
  </div>
  """
  def parse(markup) do
    image = Floki.find(markup, ".article-image.cover-image") |> Floki.attribute("style") |> List.first
    image = Regex.named_captures(~r/background-image: url\('(?<url>.*)'\);/, image) |> Map.get("url")
    title = Floki.find(markup, "h3") |> Floki.text
    link = Floki.find(markup, ".article-link") |> Floki.attribute("href") |> List.first
    time = Floki.find(markup, "time") |> Floki.text

    %{
      title: title,
      link: link,
      image: image,
      time: time
    }
  end

  def fetch do
    OneApi.Ifanr.start
    case OneApi.Ifanr.get("/") do
      {:ok, response} ->
        {:ok, response.body}
      {:error, reason} ->
        {:error, "Error #{reason}"}
    end
  end
end
