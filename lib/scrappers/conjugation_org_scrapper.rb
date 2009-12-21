require 'rubygems'
require 'scrapi'
require 'CGI'
require 'htmlentities'

module Scrappers
  class ConjugationOrgScrapper
    #
    # return a collections of Hashs(:tense, :conjugations)
    #
    def self.verb( verb_name )      
      uri = URI.parse( "http://www.conjugation.org/cgi-bin/conj.php?word=#{CGI::escape( verb_name )}&B1=Conjugate&rb1=table&dpresent_indicative=yes&dimperfect=yes&dpreterite=yes&dfuture=yes&dconditional=yes&dimperative=yes&dp_sub=yes&di_sub=yes&dgerund=yes&dp_participle=yes&rb3=yes&rb2=ra" )
      
      scraper = Scraper.define do
        array :verb_conjugations
        array :errors
        process "td", :verb_conjugations => :text
        process "strong", :errors => :text
        result :errors, :verb_conjugations
      end
      scraping_results = scraper.scrape(uri)
      
      results = []
      
      if scraping_results.errors[0].strip != 'Error :'
        scraping_results.verb_conjugations.each do |scraping_result|
          result = Hash.new
          result[:tense] = scraping_result.split("\n")[0].gsub( /:$/, '' )
          result[:conjugations] = scraping_result.split("\n")[1..-1].map { |e| HTMLEntities.new.decode( e ) }
        
          results << result
        end
      end
      
      return results
    end
    
    #
    # This method is just for build fixtures to build tests
    #
    def self.marshallice( verb_name )
      uri = URI.parse( "http://www.conjugation.org/cgi-bin/conj.php?word=#{CGI::escape( verb_name )}&B1=Conjugate&rb1=table&dpresent_indicative=yes&dimperfect=yes&dpreterite=yes&dfuture=yes&dconditional=yes&dimperative=yes&dp_sub=yes&di_sub=yes&dgerund=yes&dp_participle=yes&rb3=yes&rb2=ra" )

      File.open( "#{RAILS_ROOT}/test/fixtures/responses/conjugation_org_#{verb_name}.marshal" , 'w') do |f|
        f.write Marshal.dump( Scraper::Reader.read_page(uri) )
      end
    end
  end
end