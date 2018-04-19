require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'pg'
require 'pry'
require 'httparty'
require_relative 'db_config'    

require_relative 'db_config'
require_relative 'models/user'
# require_relative 'models/activities'

enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user #if it's truthy
      return true
    else
      return false
    end
  end
end


get '/' do
  erb :index
end

post '/session' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to('/search')
  else
    redirect to('/')
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do

end

get '/search' do
  erb :search
end

get '/weather_info' do
  url = "http://api.openweathermap.org/data/2.5/weather?q=#{params[:city]}&units=metric&APPID=150fe397273b0898d4e8b500237412d9"
  @weather_info = HTTParty.get(url)
  @weather_info
  @name = @weather_info['name']
  @main = @weather_info['weather'][0]['main']
  @img_url = "http://openweathermap.org/img/w/#{@weather_info['weather'][0]['icon']}.png"
  @temp = @weather_info['main']['temp']
  @humidity = @weather_info['main']['humidity']
  @temp_min = @weather_info['main']['temp_min']
  @temp_max = @weather_info['main']['temp_max']


# if params[:city].valid? === false
#   redirect to('/search')

  
  erb :mainpage
end
