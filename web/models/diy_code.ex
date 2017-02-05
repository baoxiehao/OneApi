defmodule OneApi.Rss.DiyCode do
  use HTTPoison.Base

  @domain "https://www.diycode.cc"

  def process_url(url) do
    @domain <> url
  end

  def process_response_body(html) do
    topics_news_selector = "div.panel-body div.topic.media"
    projects_selector = "div.panel-body div.media"
    trends_selector = "div.panel-body a.list-group-item"
    sites_selector = "div.panel-body div.site"

    topics_news = Floki.find(html, topics_news_selector) |> Enum.count
    projects = Floki.find(html, projects_selector) |> Enum.count
    trends = Floki.find(html, trends_selector) |> Enum.count
    sites = Floki.find(html, sites_selector) |> Enum.count

    IO.puts "topics_news: #{topics_news}, projects: #{projects}, trends: #{trends}, sites: #{sites}"

    cond do
      topics_news >= 10 ->
        Floki.find(html, topics_news_selector)
        |> Enum.map(&OneApi.Rss.DiyCode.parse_topics_news/1)
      projects >= 10 ->
        Floki.find(html, projects_selector)
        |> Enum.map(&OneApi.Rss.DiyCode.parse_projects/1)
      trends >= 10 ->
        Floki.find(html, trends_selector)
        |> Enum.map(&OneApi.Rss.DiyCode.parse_trends/1)
      sites >= 10 ->
        Floki.find(html, sites_selector)
        |> Enum.map(&OneApi.Rss.DiyCode.parse_sites/1)
      true ->
        html
    end
  end

  """
  <div class="topic media topic-588">
    <div class="avatar media-left">
      <a class="hacknews_clear" href="/oysun">
        <img class="media-object avatar-48" style="max-width: 252px;" src="https://diycode.cc/system/letter_avatars/2/O/255_168_0/96.png" alt="96" /></a>
    </div>
    <div class="infos media-body">
      <div class="title media-heading">
        <a title="简约漂亮的 Vue 圆环菜单组件" href="/topics/588">简约漂亮的 Vue 圆环菜单组件</a></div>
      <div class="info">
        <a class="node" href="/topics/node27">分享发现</a>•
        <a data-name="oysun" class="hacknews_clear" href="/oysun">oysun</a>
        <span class="hidden-mobile">• 于
          <abbr class="timeago" title="2017-01-29T12:31:33+08:00"></abbr>发布</span></div>
    </div>
    <div class="count media-right"></div>
  </div>
  """
  def parse_topics_news(markup) do
    image = Floki.find(markup, "div.avatar > a > img") |> Floki.attribute("src") |> List.first
    title = Floki.find(markup, "div.title > a") |> Floki.attribute("title") |> List.first
    link = Floki.find(markup, "div.title > a") |> Floki.attribute("href") |> List.first
    time = Floki.find(markup, "abbr.timeago") |> Floki.attribute("title") |> List.first

    if String.starts_with?(link, "/") do
      link = [@domain, link] |> Enum.join ""
    end

    %{
      image: image |> String.trim,
      title: title |> String.trim,
      link: link |> String.trim,
      time: time |> OneApi.Time.format
     }
  end

  """
  <div class="media">
    <div class="avatar media-left">
      <a href="/projects/google/hover">
        <img alt="hover" src="https://diycode.b0.upaiyun.com/developer_organization/avatar/101.jpg" /></a>
    </div>
    <div class="media-body">
      <div class="media-heading">
        <a href="/projects/google/hover">hover</a></div>
      <div class="info">Google 开源的 Android 浮动菜单效果库</div>
      <div class="media-footer">
        <a class="node" href="/categories/Android">Android</a>•
        <a class="hacknews_clear text-muted" href="/sub_categories/61">Menu</a></div>
    </div>
    <div class="count media-right media-middle">
      <a class="state-false badge badge-info" href="/projects/16935">
        <i class="fa fa-star"></i>&nbsp;157</a>
    </div>
  </div>
  """
  def parse_projects(markup) do
    image = Floki.find(markup, "div.avatar > a  > img") |> Floki.attribute("src") |> List.first
    title = Floki.find(markup, "div.media-heading > a") |> Floki.text
    link = Floki.find(markup, "div.media-heading > a") |> Floki.attribute("href") |> List.first
    desc = Floki.find(markup, "div.info") |> Floki.text
    tags = Floki.find(markup, "a.node") |> Floki.text

    link = [@domain, link] |> Enum.join ""

    %{
      image: image |> String.trim,
      title: title |> String.trim,
      link: link |> String.trim,
      desc: desc |> String.trim,
      tags: tags |> String.trim
    }
  end

  """
  <a class="list-group-item paginated_item" href="/projects/175">
    <img class="avatar_image_big" alt="picasso" src="https://diycode.b0.upaiyun.com/developer_organization/avatar/110.jpg" />
    <span class="name">11.
      <span class="hidden-xs hidden-sm">square/picasso</span>
      <span class="hidden-md hidden-lg">square/picasso</span></span>
    <span class="stargazers_count pull-right">
      <i class="fa fa-star"></i>12125</span>
  </a>
  """
  def parse_trends(markup) do
    image = Floki.find(markup, "img") |> Floki.attribute("src") |> List.first
    title = [
        "",#Floki.find(markup, "span.name") |> Floki.text,
        Floki.find(markup, "span.hidden-xs") |> Floki.text
      ] |> Enum.join " "
    link = markup |> Floki.attribute("href") |> List.first
    star = Floki.find(markup, "span.stargazers_count") |> Floki.text

    link = [@domain, link] |> Enum.join ""

    %{
      image: image |> String.trim,
      title: title |> String.trim,
      link: link |> String.trim,
      desc: [star |> String.trim, "stars"] |> Enum.join " "
    }
  end

  """
  <div class="col-md-2 site">
    <img class="favicon" src="https://favicon.b0.upaiyun.com/ip2/stormzhang.com.ico" alt="Stormzhang.com" />
    <a target="_blank" rel="nofollow" title="" href="http://stormzhang.com">stormzhang</a>
  </div>
  """
  def parse_sites(markup) do
    image = Floki.find(markup, "img") |> Floki.attribute("src") |> List.first
    title = Floki.find(markup, "a") |> Floki.text
    link = Floki.find(markup, "a") |> Floki.attribute("href") |> List.first

    %{
      image: image |> String.trim,
      title: title |> String.trim,
      link: link |> String.trim
    }
  end

  def fetch(params) do
    path = case Map.get(params, "path") do
      nil -> "/"
      path -> path
    end

    page = case Map.get(params, "page") do
      nil -> "1"
      page -> page
    end

    url = "/#{path}?page=#{page}"
    IO.puts "diy code request params: #{inspect params}, path = #{path}, page=#{page}, url=#{url}"

    OneApi.Rss.DiyCode.start
    case OneApi.Rss.DiyCode.get(url) do
      {:ok, response} ->
        {:ok, response.body}
      {:error, reason} ->
        {:error, "Error #{reason}"}
    end
  end
end
