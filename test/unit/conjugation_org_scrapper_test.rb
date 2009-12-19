# require 'test/unit'
require 'test_helper'

class ConjugationOrgScrapper < Test::Unit::TestCase
  def test_verb
    # Scrappers::ConjugationOrgScrapper.marshallice( 'comer' )
    
    mocked_response = Marshal.load( File.read("#{RAILS_ROOT}/test/fixtures/responses/conjugation_org_comer.marshal") )
    Scraper::Reader.stubs(:read_page).returns( mocked_response )
    
    
    # File.open( "#{RAILS_ROOT}/test/fixtures/results/conjugation_org_commer.yml", 'w' ) do |f|
    #   f.write( Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).to_yaml )
    # end
    
    assert_equal( 
      File.read( "#{RAILS_ROOT}/test/fixtures/results/conjugation_org_commer.yml"), 
      Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).to_yaml
    )
  end
  
  def test_verb_without_results
    # Scrappers::ConjugationOrgScrapper.marshallice( 'wadus' )
    
    mocked_response = Marshal.load( File.read("#{RAILS_ROOT}/test/fixtures/responses/conjugation_org_wadus.marshal") )
    Scraper::Reader.stubs(:read_page).returns( mocked_response )
    
    assert_equal( 0, Scrappers::ConjugationOrgScrapper.verb( 'wadus' ).size )
  end
end