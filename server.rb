require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/lib/scrappers/conjugation_org_scrapper.rb"
require 'haml'

get '/' do
  haml :search
end

get '/:q' do
  @results = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, haml(:not_results))  if @results.empty?
  haml(:show)
end