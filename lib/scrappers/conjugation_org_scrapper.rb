require 'rubygems'
require 'nokogiri'
require 'cgi'
require 'htmlentities'
require 'open-uri'

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
      doc = Nokogiri::HTML( open_url( uri ) )
      result = {}
      result[:tenses] = []
            
      doc.css('td').each do |td|
        tense = Hash.new
        tense[:name] = td.children[0].text.gsub(/:$/, '')
        tense[:conjugations] = []
        td.children[2..-1].each do |conjugation|
          tense[:conjugations] << HTMLEntities.new.decode( conjugation.text )  if conjugation.text != ''
        end
        
        result[:tenses] << tense
      end
        
      return result
    end
    
    def self.open_url( url )
      open( url )
    end
  end
end