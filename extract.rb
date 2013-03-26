require 'open-uri'
require 'nokogiri'
require 'mida'

sitemap = Nokogiri::HTML(open('http://d.lib.ncsu.edu/student-leaders/sitemap.xml'))
sitemap.xpath('//loc').each do |loc|
  url = loc.content
  open(url) { |f| puts Mida::Document.new(f, url).items }
end
