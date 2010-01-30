require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/lib/scrappers/conjugation_org_scrapper.rb"
require 'haml'

get '/' do
  haml :search
end

get '/:q.json' do
  @results = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, 'ERROR: not results')  if @results.empty?
  
  result = ""
  @results.each do |tense|
    result += "|"  if !result.empty?
    result += "#{tense[:tense]}:"
    result += tense[:conjugations].join(',')
  end
  
  result
end

get '/:q' do
  @results = Scrappers::ConjugationOrgScrapper.verb( params[:q] )
  halt(404, haml(:not_results))  if @results.empty?
  haml(:show)
end

