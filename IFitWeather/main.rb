require 'pry'
require_relative 'db_config'    
require 'sinatra'

get '/' do
  erb :index
end

get '/signup' do
  erb :signup
end



