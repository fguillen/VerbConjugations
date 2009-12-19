require 'test_helper'

class WrScrapperTest < ActiveSupport::TestCase
  def test_verb
    puts Scrappers::WrScrapper.verb( 'buscar' )
  end
end