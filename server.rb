require 'rubygems'
require 'sinatra'
require 'erb'
require "#{File.dirname(__FILE__)}/lib/scrappers/conjugation_org_scrapper.rb"

get '/' do
  erb(:search)
end

get '/:q' do
  @results = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, erb(:not_results))  if @results.empty?
  erb(:show)
end