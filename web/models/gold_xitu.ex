defmodule OneApi.Rss.GoldXitu do
  use HTTPoison.Base

  @domain "https://gold.xitu.io/"

  def process_url(url) do
    @domain
  end

  def process_response_body(html) do
    Floki.find(html, "div.entry.clearfix")
    |> Enum.map(&OneApi.Rss.GoldXitu.parse/1)
  end

  """
  <div @click="clickRouteEntry(&quot;http://mp.weixin.qq.com/s?__biz=MzI4NTQ2OTI4MA==&amp;mid=2247483683&amp;idx=1&amp;sn=60867e12b4aded55c18721c9ff61d915&amp;chksm=ebeafe2cdc9d773a4266032a286183895c0d8d1394755bb14a2a95b9bc76615c66bbd11a8c00&amp;mpshare=1&amp;scene=1&amp;srcid=0128eRkSZQMERixjYlgni3Nw#rd&quot;, $event)" class="entry clearfix">
     <div class="entry-screenshot float-left"><img v-lazy="&quot;https://dn-mhke0kuv.qbox.me/d645105da354d144109b.jpg?imageView/1/w/120/h/120/q/100/format/png&quot;" class="entry-screenshot-image"/></div>
     <div class="entry-info float-left">
        <div class="entry-title ellipsis">[翻译] Google 大牛告诉你一天时间能学些什么</div>
        <div class="entry-meta">
           <div class="action collection-action"><i class="ion-heart icon-heart"></i><span>186</span></div>
           <div @click="goToUser(&quot;56e101dad342d3005406cc64&quot;)" class="action entry-username">光源_Android</div>
           <div class="action"> ·</div>
           <div class="action">5天前</div>
           <div @click="showRegisterCover" class="action entry-meta-more dropdown dropdown-hover">
              <i class="ion-more dropdown-active"></i>
              <ul class="dropdown-list">
                 <li><a href="http://service.weibo.com/share/share.php?title=%E6%88%91%E5%9C%A8%20%40%E7%A8%80%E5%9C%9F%E5%9C%88%20%E7%9C%8B%E6%8A%80%E6%9C%AF%E5%B9%B2%E8%B4%A7%20-%20%5B%E7%BF%BB%E8%AF%91%5D%20Google%20%E5%A4%A7%E7%89%9B%E5%91%8A%E8%AF%89%E4%BD%A0%E4%B8%80%E5%A4%A9%E6%97%B6%E9%97%B4%E8%83%BD%E5%AD%A6%E4%BA%9B%E4%BB%80%E4%B9%88&amp;url=https://gold.xitu.io/entry/588c856e5c497d0056c07df7" target="_blank"><img src="https://gold-cdn.xitu.io/images/weibo.svg" class="inline"/><span>微博分享</span></a></li>
                 <li><a href="http://getpocket.com/edit?url=http://mp.weixin.qq.com/s?__biz=MzI4NTQ2OTI4MA==&amp;mid=2247483683&amp;idx=1&amp;sn=60867e12b4aded55c18721c9ff61d915&amp;chksm=ebeafe2cdc9d773a4266032a286183895c0d8d1394755bb14a2a95b9bc76615c66bbd11a8c00&amp;mpshare=1&amp;scene=1&amp;srcid=0128eRkSZQMERixjYlgni3Nw#rd" target="_blank"><i class="ion-android-archive"></i><span>Pocket</span></a></li>
                 <li><a href="http://www.addtoany.com/add_to/evernote?linkurl=http://mp.weixin.qq.com/s?__biz=MzI4NTQ2OTI4MA==&amp;mid=2247483683&amp;idx=1&amp;sn=60867e12b4aded55c18721c9ff61d915&amp;chksm=ebeafe2cdc9d773a4266032a286183895c0d8d1394755bb14a2a95b9bc76615c66bbd11a8c00&amp;mpshare=1&amp;scene=1&amp;srcid=0128eRkSZQMERixjYlgni3Nw#rd&amp;linkname=[翻译] Google 大牛告诉你一天时间能学些什么" target="_blank"><i class="ion-clipboard"></i><span>Evernote</span></a></li>
                 <li><a href="https://gold.xitu.io/entry/588c856e5c497d0056c07df7" target="_blank"><i class="ion-share"></i><span>分享页面</span></a></li>
              </ul>
           </div>
        </div>
     </div>
  </div>
  """
  def parse(markup) do
    title = Floki.find(markup, "div.entry-title") |> Floki.text
    link = Floki.find(markup, "a[href^=https]") |> Floki.attribute("href") |> List.first
    image = Floki.find(markup, "img.entry-screenshot-image") |> Floki.attribute("v-lazy") |> List.first |> String.replace("\"", "")

    %{
      title: title,
      link: link,
      image: (if String.starts_with?(image, "/"), do: @domain <> image, else: image)
    }
  end

  def fetch do
    OneApi.Rss.GoldXitu.start
    case OneApi.Rss.GoldXitu.get("/") do
      {:ok, response} ->
        {:ok, response.body}
      {:error, reason} ->
        {:error, "Error #{reason}"}
    end
  end
end
