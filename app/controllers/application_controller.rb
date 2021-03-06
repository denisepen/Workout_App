require './config/environment'
require 'rack-flash'
#  require 'sinatra/redirect_with_flash'

 register Sinatra::ActiveRecordExtension


class ApplicationController < Sinatra::Base

  enable :sessions
  use Rack::Flash, :sweep => true
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :homepage
  end

  helpers do
  		def logged_in?
  			!!session[:user_id]
  		end

  		def current_user
  			User.find(session[:user_id])
  		end
  	end
  end
