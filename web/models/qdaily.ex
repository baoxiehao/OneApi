defmodule OneApi.Rss.QDaily do
  use HTTPoison.Base

  @domain "http://www.qdaily.com"

  def process_url(url) do
    @domain
  end

  def process_response_body(html) do
    Floki.find(html, "div.packery-item")
    |> Enum.map(&OneApi.Rss.QDaily.parse_item/1)
  end

  """
  <div class="grid-articles-banner-hd">
     <a href="/articles/37229.html" class="category-title hidden">
        <p class="category">商业</p>
        <h3 class="title smart-lines" data-origintext="他让冷藏车真正发挥了商业价值，并影响了我们如何吃肉｜我们的生活是这样被设计的"><span class="line">他让冷藏车真正发挥了商业价值，并影响了我们如何吃肉｜我们的生活是这样被设计的</span></h3>
     </a>
     <a href="/articles/37395.html" class="category-title hidden">
        <p class="category">娱乐</p>
        <h3 class="title smart-lines" data-origintext="当篮协主席，这是姚明的失败还是中国篮球的失败？"><span class="line">当篮协主席，这是姚明的失败还是中国篮球的失败？</span></h3>
     </a>
     <a href="/cards/37363.html" class="category-title hidden">
        <p class="category">智能</p>
        <h3 class="title smart-lines" data-origintext="假期最后一天，我们推荐这 16 个应用帮你回血 | 春节不鸡汤指南"><span class="line">假期最后一天，我们推荐这 16 个应用帮你回血 | 春节不鸡汤指南</span></h3>
     </a>
     <a href="/articles/37376.html" class="category-title hidden">
        <p class="category">城市</p>
        <h3 class="title smart-lines" data-origintext="如今的弊端未来要由年轻人解决，我们做了什么样的准备 | 这个社会，对年轻人太好了吗？③"><span class="line">如今的弊端未来要由年轻人解决，我们做了什么样的准备 | 这个社会，对年轻人太好了吗？③</span></h3>
     </a>
     <a href="/articles/36688.html" class="category-title hidden">
        <p class="category">城市</p>
        <h3 class="title smart-lines" data-origintext="一个摄影师走在缅甸的大街上，她说一切都和自由有关 | 指南针"><span class="line">一个摄影师走在缅甸的大街上，她说一切都和自由有关 | 指南针</span></h3>
     </a>
  </div>
  """
  def parse_banner(markup) do
    title = Floki.find(markup, "h3.title.smart-lines") |> Floki.attribute("data-origintext") |> List.first
    link = Floki.attribute(markup, "href") |> List.first

    %{
      title: title,
      link: @domain <> link,
      source: "好奇心日报"
    }
  end

  """
  <div class="packery-item article">
     <a href="/articles/37406.html" class="com-grid-article">
        <div class="grid-article-hd">
           <div class="pic imgcover"><img class="lazyload" data-src="http://img.qdaily.com/article/article_show/2017020311083189iuNMO1ebItDTK2.jpg?imageMogr2/auto-orient/thumbnail/!245x185r/gravity/Center/crop/245x185/quality/85/format/jpg/ignore-error/1" alt="这一季亚马逊赚了不少钱，但股价跌了"></div>
           <p class="category"><span class="iconfont icon-zhineng-bg"></span> <span>智能</span></p>
        </div>
        <div class="grid-article-bd">
           <h3 class="smart-dotdotdot">这一季亚马逊赚了不少钱，但股价跌了</h3>
        </div>
        <div class="grid-article-ft clearfix">
           <span class="smart-date" data-origindate="2017-02-03 13:49:41 +0800"></span>
           <div class="ribbon">   <span class="iconfont icon-heart">4</span>  </div>
        </div>
     </a>
  </div>
  """
  def parse_item(markup) do
    title = Floki.find(markup, "h3") |> Floki.text
    link = Floki.find(markup, "a") |> Floki.attribute("href") |> List.first
    image = Floki.find(markup, "div.imgcover.pic > img") |> Floki.attribute("data-src") |> List.first
    time = Floki.find(markup, "span.smart-date") |> Floki.attribute("data-origindate") |> List.first

    %{
      title: title,
      link: @domain <> link,
      image: image,
      time: time |> OneApi.Time.format,
      source: "好奇心日报"
    }
  end

  def fetch do
    OneApi.Rss.QDaily.start
    case OneApi.Rss.QDaily.get("/") do
      {:ok, response} ->
        {:ok, response.body}
      {:error, reason} ->
        {:error, "Error #{reason}"}
    end
  end
end
