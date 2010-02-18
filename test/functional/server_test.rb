require 'test/unit'
require "#{File.dirname(__FILE__)}/../../server.rb"
require 'rack/test'
require 'mocha'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.ok?
  end

  def test_with_params
    verb_fixture = YAML::load( File.read( "#{File.dirname(__FILE__)}/../fixtures/results/conjugation_org_commer.yml" ) )
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('comer').returns(verb_fixture).once
    get '/comer'
    assert last_response.ok?
    assert_match /wadus/, last_response.body
    assert_match /yo como/, last_response.body
  end

  def test_not_found_verb
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('wadus').returns(nil).once
    get '/wadus'
    assert_equal(404, last_response.status)
    assert_match /Verb 'wadus' not found/, last_response.body
  end
  
  def test_not_found_verb_with_json_format
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('wadus').returns(nil).once
    get '/wadus.json'
    assert_equal(404, last_response.status)
    assert_match /^ERROR/, last_response.body
  end
  
  def test_with_params_with_json_format
    verb_fixture = YAML::load( File.read( "#{File.dirname(__FILE__)}/../fixtures/results/conjugation_org_commer.yml" ) )
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('comer').returns(verb_fixture).once
    
    get '/comer.json'
    assert last_response.ok?
    assert_equal( 
      JSON.parse( File.read( "#{File.dirname(__FILE__)}/../fixtures/results/comer.json" ) ), 
      JSON.parse( last_response.body )
    )
  end
end
