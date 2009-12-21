module Scrappers
  
  class WrScrapper
    def self.verb( verb_name )      
      uri = URI.parse( "http://www.wordreference.com/conj/ESverbs.asp?v=#{CGI::escape( verb_name )}" )
      
      scraper = Scraper.define do
        array :contents
        process "table table table td", :contents => :text
        result :contents
      end
      
      scraping_results = scraper.scrape(uri)
      
      results = []
      scraping_results.each do |scraping_result|
        result = HTMLEntities.new.decode( scraping_result ).strip
        results << result  if !result.blank?
      end
      
      results
    end
  end
end