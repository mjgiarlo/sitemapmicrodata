require 'open-uri'
require 'nokogiri'
require 'microdata'

sitemap_index = open(ARGV[0]).read

beginning_time = Time.now
resources_count = 0

Nokogiri::HTML(sitemap_index).xpath('//loc').each do |sitemap_loc|
  sitemap_gz = open(sitemap_loc)
  sitemap = Zlib::GzipReader.new( sitemap_gz ).read
  Nokogiri::HTML(sitemap).xpath('//loc').each do |loc|
    url = loc.content
    open(url) do |f|
      items = Microdata::Document.new(f, url).extract_items
      items.each do |item|
        puts JSON.pretty_generate(item.to_hash)
      end
    end
    resources_count += 0
  end
end

puts "Total resources: #{resources_count}"
puts "Time elapsed #{Time.now - beginning} seconds"