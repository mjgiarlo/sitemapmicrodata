require 'open-uri'
require 'nokogiri'
require 'microdata'
require 'rubberband'
require 'springboard'

sitemap_index = open(ARGV[0]).read

es_client = ElasticSearch.new('http://localhost:9200', :index => "resources", :type => "resource")

beginning_time = Time.now
resources_count = 0
indexed_resources = 0

Nokogiri::HTML(sitemap_index).xpath('//loc').each do |sitemap_loc|
  puts sitemap_loc.text
  sitemap = open(sitemap_loc)
  begin
    sitemap = Zlib::GzipReader.new( sitemap ).read
  rescue => e
    sitemap = sitemap.read
  end
  Nokogiri::HTML(sitemap).xpath('//loc').each do |loc|
    url = loc.content
    open(url) do |f|
      items = Microdata::Document.new(f, url).extract_items
      items.each do |item|
        puts JSON.pretty_generate(item.to_hash)
        begin # sometimes the data isn't to ES's liking--like values that are empty strings
          es_client.index(item.to_hash.merge(:url => url)) 
          indexed_resources += 1
        rescue
        end       
      end
    end
    resources_count += 0
  end
end

puts "Total resources: #{resources_count}"
puts "Indexed resources: #{indexed_resources}"
puts "Time elapsed #{Time.now - beginning_time} seconds"