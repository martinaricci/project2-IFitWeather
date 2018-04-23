require 'sinatra'
require 'active_record'
require 'pg'
require 'pry'
require 'httparty'
require_relative 'db_config'    

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/city_weather'
ActiveRecord::Base.logger = Logger.new(STDERR)
# require_relative 'models/activiaties'

binding.pry
