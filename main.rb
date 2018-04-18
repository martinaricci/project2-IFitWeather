require 'pry'
require_relative 'db_config'    
require 'sinatra'
require 'active_record  '

get '/' do
  erb :index
end

get '/signup' do
  erb :signup
end



