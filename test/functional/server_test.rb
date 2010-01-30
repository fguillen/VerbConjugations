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
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('comer').returns([{:tense => 'wadus', :conjugations => ['conjugation1']}]).once
    get '/comer'
    assert last_response.ok?
    assert_match /wadus/, last_response.body
    assert_match /conjugation1/, last_response.body
  end

  def test_not_found_verb
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('wadus').returns([]).once
    get '/wadus'
    assert_equal(404, last_response.status)
    assert_match /Verb 'wadus' not found/, last_response.body
  end
  
  def test_not_found_verb_with_json_format
    Scrappers::ConjugationOrgScrapper.expects(:verb).with('wadus').returns([]).once
    get '/wadus.json'
    assert_equal(404, last_response.status)
    assert_match /^ERROR/, last_response.body
  end
  
  def test_with_params_with_json_format
    Scrappers::ConjugationOrgScrapper.
      expects(:verb).
      with('comer').
      returns(
        [
          {:tense => 'presente', :conjugations => ['yo como', 'tu comes', 'el come']},
          {:tense => 'pasado', :conjugations => ['yo comí', 'tu comiste', 'el comió']}
        ]).once
        
    get '/comer.json'
    assert last_response.ok?
    assert_equal( "presente:yo como,tu comes,el come|pasado:yo comí,tu comiste,el comió", last_response.body)
  end
end
