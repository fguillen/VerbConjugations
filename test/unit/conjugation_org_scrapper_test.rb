require 'test/unit'
require 'rubygems'
require 'mocha'
require "#{File.dirname(__FILE__)}/../../lib/scrappers/conjugation_org_scrapper.rb"

class ConjugationOrgScrapper < Test::Unit::TestCase
  def test_verb
    mocked_response = Marshal.load( File.read("#{File.dirname(__FILE__)}/../fixtures/responses/conjugation_org_comer.marshal") )
    Scraper::Reader.stubs(:read_page).returns( mocked_response )
    
    assert_equal( 
      File.read( "#{File.dirname(__FILE__)}/../fixtures/results/conjugation_org_commer.yml"), 
      Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).to_yaml
    )
  end
  
  def test_verb_without_results
    mocked_response = Marshal.load( File.read("#{File.dirname(__FILE__)}/../fixtures/responses/conjugation_org_wadus.marshal") )
    Scraper::Reader.stubs(:read_page).returns( mocked_response )
    
    assert_equal( 0, Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).size )
  end
end

# This are utils for build the fixtures and tests
#
# Scrappers::ConjugationOrgScrapper.marshallice( 'comer' )
# File.open( "#{File.dirname(__FILE__)}/../fixtures/results/conjugation_org_commer.yml", 'w' ) do |f|
#   f.write( Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).to_yaml )
# end
