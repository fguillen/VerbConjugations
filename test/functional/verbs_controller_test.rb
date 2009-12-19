require 'test_helper'

class VerbsControllerTest < ActionController::TestCase
  def test_on_show
    get( :show, :q => 'buscar' )
    puts @response.body
  end
end