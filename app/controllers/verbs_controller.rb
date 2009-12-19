class VerbsController < ApplicationController
  def show
    @results = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  end
end