require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/lib/scrappers/conjugation_org_scrapper.rb"
require 'haml'
require 'json'

get '/' do
  haml :search
end

get '/:q.json' do
  @verb = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, 'ERROR: not results')  if @verb.nil?
  
  JSON.generate(@verb)
end

get '/:q' do
  @verb = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, haml(:not_results))  if @verb.nil?
  haml(:show)
end

