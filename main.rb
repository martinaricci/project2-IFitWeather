require 'sinatra'
require 'active_record'
require 'pry'
require_relative 'db_config'    

get '/' do
  erb :index
end

get '/signup' do
  erb :signup
end



