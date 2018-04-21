options = {
    adapter: 'postgresql',
    database: 'ifitweather'
}

#it establishes a connection with heroku dababase, if it fails, it goes back to your own.
ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)