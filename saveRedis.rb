# coding: utf-8

require 'redis'
require 'json'

if ARGV.size < 1
  raise "引数にファイル名を"
  exit
end
input_filename = ARGV[0].to_s
raise "file not found" unless File.exist?(input_filename)

redis = Redis.new

lines = nil
File.open(input_filename, 'r') do |f|
  lines = f.read
end

lines.split(/\r?\n/).each do |line|
  data  = line.split(/\t/)
  next if data[2].to_s.size < 10
  json = JSON.generate({
    'key'   => data[0],
    'date'  => data[1],
    'title' => data[2],
    })
  redis.sadd('newsList', json.to_s)
end
