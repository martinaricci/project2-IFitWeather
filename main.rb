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

def run_query(sql)
    conn = PG.connect(dbname: 'ifitweather')
    result = conn.exec(sql)
    conn.close
    return result
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
    # 'hello'
    erb :signup
end

post '/signup' do
    # redirect to('/search')
    User.create(username: params[:username],
                password: params[:password])
                redirect to('/')
    'hello'
end

get '/search' do
    erb :search
end

get '/weather_info' do
    sql = PG.connect(dbname: 'ifitweather')
    @weather_info = sql.exec("SELECT * FROM city_weather WHERE name ILIKE '#{params[:city]}' order by id desc;")
    # url = "http://api.openweathermap.org/data/2.5/weather?q=#{params[:city]}&units=metric&APPID=150fe397273b0898d4e8b500237412d9"
    # @weather_info = HTTParty.get(url)
    @weather_info = @weather_info[0]
    @name = @weather_info['name']
    @main = @weather_info['main']
    @img_url = "http://openweathermap.org/img/w/#{@weather_info['icon']}.png"
    @temp = @weather_info['temp']
    @humidity = @weather_info['humidity']
    @temp_min = @weather_info['temp_min']
    @temp_max = @weather_info['temp_max']

    erb :forecast
end

post '/weather_info' do
    sql = PG.connect(dbname: 'ifitweather')
    @weather_info = sql.exec("SELECT * FROM city_weather WHERE name ILIKE '#{params[:city]}' order by id desc;")

    if @weather_info.count > 0
        @weather_info = @weather_info[0]
        @name = @weather_info['name']
        @main = @weather_info['main']
        @img_url = "http://openweathermap.org/img/w/#{@weather_info['icon']}.png"
        @temp = @weather_info['temp']
        @humidity = @weather_info['humidity']
        @temp_min = @weather_info['temp_min']
        @temp_max = @weather_info['temp_max']
    else
        url = "http://api.openweathermap.org/data/2.5/weather?q=#{params[:city]}&units=metric&APPID=150fe397273b0898d4e8b500237412d9"
        @weather_info = HTTParty.get(url)
        @name = @weather_info['name'].downcase
        @main = @weather_info['weather'][0]['main']
        @img_url = "http://openweathermap.org/img/w/#{@weather_info['weather'][0]['icon']}.png"
        @temp = @weather_info['main']['temp']
        @humidity = @weather_info['main']['humidity']
        @temp_min = @weather_info['main']['temp_min']
        @temp_max = @weather_info['main']['temp_max']
        sql_city = "INSERT INTO city_weather(name, icon, main, temp, humidity, temp_min, temp_max) VALUES ('#{@name}', '#{@main}', '#{@img_url}', '#{@temp}', '#{@humidity}', '#{@temp_min}', '#{@temp_max}')"

        sql.exec(sql_city)
    end

    redirect to('/weather_info?city=' + params[:city])
end
