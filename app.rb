# coding: utf-8

require 'sinatra'
require 'redis'
require 'erubis'
require 'json'

# for debug
require "sinatra/reloader" if development?

# settings
include Rack::Utils

get '/' do
  erb :index
end

post '/list' do
  redis = Redis.new
  data = redis.get('newsListCache')
  unless data
    list = []
    25.times do |i|
      list.push JSON.parse(redis.srandmember('newsList'))
    end
    data = JSON.generate(list)
    redis.setex('newsListCache', 30, data)
  end
  data
end

__END__

@@ index
<!DOCTYPE html>
<html lang="ja" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
    <title>Olds速報</title>
    <link href="style.css" rel="stylesheet" type="text/css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
    <script src="olds.js"></script>
    <script src="jquery.socialbutton-1.9.0.min.js"></script>
  </head>
  <body>
    <div id="wrapper">
      <header id="global-header">
        <h1 class="site-title">Olds速報</h1>
        <p class="description">昔のニュースの見出しを眺めてみよう</p>
      </header>
      <ul id="news">
        <li><a href="" target="_blank">
          <div class="date"></div>
          <div class="title"></div>
        </a></li>
      </ul>
      <ul id="social-button">
        <li class="hatebu"></li>
        <li class="twitter"></li>
      </ul>
      <footer id="global-footer">
        <p class="copyright">このページをつくったひと：<a href="http://twitter.com/ru_shalm">@ru_shalm</a></p>
        <p class="description">※このページの見出し記事は<a href="http://headlines.yahoo.co.jp/hl">Yahoo!ニュース</a>の過去の記事を<a href="http://archive.org">Internet Archive</a>から引用しています</p>
      </footer>
    </div>
    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-36737651-3']);
      _gaq.push(['_trackPageview']);
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
  </body>
</html>