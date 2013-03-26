require 'open-uri'
require 'nokogiri'
require 'microdata'

Nokogiri::HTML(open('http://d.lib.ncsu.edu/student-leaders/sitemap.xml')).xpath('//loc').each do |loc|
  url = loc.content
  open(url) do |f|
    items = Microdata::Document.new(f, url).extract_items
    items.each do |item|
      puts JSON.pretty_generate(item.to_hash)
    end
  end
end
