require 'rubygems'
require 'scrapi'
require 'cgi'
require 'htmlentities'

module Scrappers
  class ConjugationOrgScrapper
    #
    # return an structure like this
    #  :name => 'verb name',
    #  :tenses => [
    #     {:name => 'tense name1', :conjugations => ['conj1-1', 'conj1-2'] }
    #     {:name => 'tense name2', :conjugations => ['conj2-1', 'conj2-2'] }
    #  ]
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
            
      if scraping_results.errors[0].strip != 'Error :'
        result = Hash.new
        result[:name] = verb_name
        result[:tenses] = []
        
        scraping_results.verb_conjugations.each do |scraping_result|
          tense = Hash.new
          tense[:name] = scraping_result.split("\n")[0].gsub( /:$/, '' )
          tense[:conjugations] = scraping_result.split("\n")[1..-1].map { |e| HTMLEntities.new.decode( e ) }
        
          result[:tenses] << tense
        end
        
        return result
      end
      
      return nil
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