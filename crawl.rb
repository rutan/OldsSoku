# coding: utf-8

require 'mechanize'

YAHOO_NEWS_URL = "http://headlines.yahoo.co.jp/hl"
REPLACE_TEXT = "____replace____"
ARCHIVE_URL = "http://web.archive.org/web/#{REPLACE_TEXT}0301000000*/#{YAHOO_NEWS_URL}"

if ARGV.size < 1
  raise "引数に取得したい西暦の年数を入力してやり直すのじゃ"
  exit
end
input_year = ARGV[0].to_i
raise "2001年以前は無いのら！" if input_year < 2001
raise "なんという未来！" if input_year > Time.now.year

# 探すぞー
mechanize = Mechanize.new
list_page = mechanize.get(ARCHIVE_URL.sub(REPLACE_TEXT, input_year.to_s))
list_page.search('.date ul li a').each_with_index do |link, i|
  next_url = link['href']
  begin
    next_page = mechanize.get(next_url)
    next_page.search('a').each do |archive_link|
      if archive_link['href'] =~ /hl\?a=(\d{4})(\d{2})(\d{2})-\d+-/
        data = []
        data.push archive_link['href']
        data.push "#{$1.to_i}-#{$2.to_i}-#{$3.to_i}"
        text = archive_link.inner_text.gsub("\t", '')
        next if text.size < 10 # 記事名が短い＝たいてい検出ミス。直す気はない。
        data.push text
        puts data.join("\t")
      end
    end
  rescue
    # 例外は握りつぶす
  end
  sleep 1  # あんまり連続で叩くと不正アクセスになりそう
end
