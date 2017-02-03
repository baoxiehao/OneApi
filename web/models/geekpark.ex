defmodule OneApi.GeekPark do
  use HTTPoison.Base

  @domain "http://www.geekpark.net"

  def process_url(url) do
    @domain
  end

  def process_response_body(html) do
    Floki.find(html, "article.article-item")
    |> Enum.map(&OneApi.GeekPark.parse/1)
  end

  """
  <article class="article-item">
     <a class="dib-top img-cover-wrap" data-event-action="view" data-event-category="home.article-list.cover" data-event-label="被红包充斥的除夕夜过去了，这里是关于红包你需要知道的所有玩法和数据 /topics/217806" href="/topics/217806" target="_blank">
        <div class="responsive-img"><img alt="被红包充斥的除夕夜过去了，这里是关于红包你需要知道的所有玩法和数据" class="img-cover js-lazy" data-ratio="0.618" data-src="https://ocpk3ohd2.qnssl.com/uploads/image/file/e4/57/e457f96d87d6933bcae763d43606c1c3.jpeg" data-vw="22" /></div>
     </a>
     <div class="dib-top article-info">
        <div class="article-info-wrapper">
           <a class="category-tag" data-event-action="view" data-event-category="home.article-list.category-link" data-event-label="今日看点" href="/collections/%E4%BB%8A%E6%97%A5%E7%9C%8B%E7%82%B9" style="background-color: #BF6505;" target="_blank">今日看点</a><a class="article-title" data-event-action="view" data-event-category="home.article-list.title" data-event-label="被红包充斥的除夕夜过去了，这里是关于红包你需要知道的所有玩法和数据" href="/topics/217806" target="_blank">被红包充斥的除夕夜过去了，这里是关于红包你需要知道的所有玩法和数据</a>
           <p class="article-description">朋友，抢了多少红包了？</p>
           <div class="article-source">
              <div class="source-left"><span class="author-divide">|</span><a class="dib-middle article-author" data-event-action="view" data-event-category="home.article-list.author" data-event-label="张雨忻" href="/users/412656" target="_blank">张雨忻</a><span class="dib-middle article-publish"><i class="iconfont icon-time dib-middle"></i><a class="article-time js-relative-time dib-middle" data-time="1485571920" href="javascript:;" title="2017-01-28 10:52:00"></a></span></div>
              <a class="source-right" data-event-action="view" data-event-category="home.article-list.comment" data-event-label="评论数：2 文章：被红包充斥的除夕夜过去了，这里是关于红包你需要知道的所有玩法和数据" href="/topics/217806#comments" target="_blank">
                 <svg class="icon-comment" height="20px" version="1.1" viewBox="0 0 24 20" width="24px">
                    <title>comment icon</title>
                    <g fill="none" fill-rule="evenodd" id="Page-1" stroke="none" stroke-width="1">
                       <g fill="#BF6505" id="Artboard" transform="translate(-1816.000000, -320.000000)">
                          <path d="M1816,320 L1840,320 L1840,335.652174 L1816,335.652174 L1816,320 Z M1821.21739,339.304348 L1816,335.652174 L1821.21739,335.652174 L1821.21739,339.304348 Z" id="Combined-Shape"></path>
                       </g>
                    </g>
                 </svg>
                 <span>2</span>
              </a>
           </div>
        </div>
     </div>
  </article>
  """
  def parse(markup) do
    image = Floki.find(markup, "div.responsive-img > img") |> Floki.attribute("data-src") |> List.first
    title = Floki.find(markup, "div.responsive-img > img") |> Floki.attribute("alt") |> List.first
    link = Floki.find(markup, "a.dib-top.img-cover-wrap") |> Floki.attribute("href") |> List.first
    desc = Floki.find(markup, "p.article-description") |> Floki.text
    time = Floki.find(markup, "a.article-time") |> Floki.attribute("title") |> List.first

    %{
      title: title,
      link: @domain <> link,
      image: image,
      desc: desc,
      time: time
    }
  end

  def fetch do
    OneApi.GeekPark.start
    case OneApi.GeekPark.get("/") do
      {:ok, response} ->
        {:ok, response.body}
      {:error, reason} ->
        {:error, "Error #{reason}"}
    end
  end
end
