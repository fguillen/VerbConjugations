require 'test/unit'
require 'rubygems'
require 'mocha'
require "#{File.dirname(__FILE__)}/../../lib/scrappers/conjugation_org_scrapper.rb"

class ConjugationOrgScrapper < Test::Unit::TestCase
  def test_verb
    mocked_response = File.read("#{File.dirname(__FILE__)}/../fixtures/responses/conjugation_org_comer.html")
    Scrappers::ConjugationOrgScrapper.stubs(:open_url).returns( mocked_response )
    
    puts Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).to_yaml
    
    assert_equal( 
      File.read( "#{File.dirname(__FILE__)}/../fixtures/results/conjugation_org_commer.yml" ), 
      Scrappers::ConjugationOrgScrapper.verb( 'comer' ).to_yaml
    )
  end

  # def test_verb_with_nokogiri
  #   doc = Nokogiri::HTML( File.read( "#{File.dirname(__FILE__)}/../fixtures/responses/conjugation_org_comer.html" ) )
  #   doc.css('td').each do |td|
  #     puts ""
  #     puts td.children[0].text.gsub(/:$/, '')
  #     puts "----------"
  #     td.children[2..-1].each do |conj|
  #       puts conj.text  if conj.text != ''
  #     end
  #   end
  # end
  
  def test_verb_without_results
    mocked_response = Marshal.load( File.read("#{File.dirname(__FILE__)}/../fixtures/responses/conjugation_org_wadus.marshal") )
    Scrappers::Reader.stubs(:read_page).returns( mocked_response )
    
    assert_equal( nil, Scrappers::ConjugationOrgScrapper.verb( 'wadus' ) )
  end
end
