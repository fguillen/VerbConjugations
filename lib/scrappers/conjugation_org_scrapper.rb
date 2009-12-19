module Scrappers
  class ConjugationOrgScrapper
    
    def self.marshallice( verb_name )
      uri = URI.parse( "http://www.conjugation.org/cgi-bin/conj.php?word=#{CGI::escape( verb_name )}&B1=Conjugate&rb1=table&dpresent_indicative=yes&dimperfect=yes&dpreterite=yes&dfuture=yes&dconditional=yes&dimperative=yes&dp_sub=yes&di_sub=yes&dgerund=yes&dp_participle=yes&rb3=yes&rb2=ra" )

      File.open( "#{RAILS_ROOT}/test/fixtures/responses/conjugation_org_#{verb_name}.marshal" , 'w') do |f|
        f.write Marshal.dump( Scraper::Reader.read_page(uri) )
      end
    end
    
    #
    # return a collections of VerbConjugations
    #
    def self.verb( verb_name )      
      uri = URI.parse( "http://www.conjugation.org/cgi-bin/conj.php?word=#{CGI::escape( verb_name )}&B1=Conjugate&rb1=table&dpresent_indicative=yes&dimperfect=yes&dpreterite=yes&dfuture=yes&dconditional=yes&dimperative=yes&dp_sub=yes&di_sub=yes&dgerund=yes&dp_participle=yes&rb3=yes&rb2=ra" )
      
      
      
      # puts Scraper::Reader.read_page(uri)
      
      #   array :items  
      #   process "div.item", :items => Scraper.define {  
      #     process "a.prodLink", :title => :text  
      #     process "div.priceAvail>div>div.PriceCompare>div.BodyS", :price => :text  
      #     result :price, :title  
      #   }  
      #   result :items
      
      scraper = Scraper.define do
        array :verb_conjugations
        array :errors
        process "td", :verb_conjugations => :text
        process "strong", :errors => :text
        result :errors, :verb_conjugations
      end
      scraping_results = scraper.scrape(uri)
      
      verb_conjugations = []
      
      # puts "XXX: scraping_results.errors: #{scraping_results.errors.join( ',' )}"
      if scraping_results.errors[0].strip != 'Error :'
        scraping_results.verb_conjugations.each do |scraping_result|
          verb_conjugation = VerbConjugation.new()
          verb_conjugation.tense = scraping_result.split("\n")[0].gsub( /:$/, '' )
          verb_conjugation.conjugation = scraping_result.split("\n")[1..-1].map { |e| HTMLEntities.new.decode( e ) }
        
          verb_conjugations << verb_conjugation
        end
      end
      
      return verb_conjugations
    end
  end
end