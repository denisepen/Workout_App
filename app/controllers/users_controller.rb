require './config/environment'
require 'rack-flash'
 require 'sinatra/redirect_with_flash'

 register Sinatra::ActiveRecordExtension

class UsersController < ApplicationController


  get '/signup' do
    erb :'/users/signup'
  end

  get '/login' do
    erb :'/users/login'
  end

  get '/landing' do
    @user = User.find(session[:user_id])
    erb :"/users/landing"
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/users/workouts' do
    # binding.pry
    #shows a list of all the users workouts
    @user=User.find(session[:user_id])

    if !@user.workouts.where(workout: "Bike").empty?
      @bike_wkts = @user.workouts.where(workout: "Bike")
    end
    if !@user.workouts.where(workout: "Run").empty?
      @run_wkts = @user.workouts.where(workout: "Run")
    end
    if !@user.workouts.where(workout: "Swim").empty?
      @swim_wkts = @user.workouts.where(workout: "Swim")
    end
    if !@user.workouts.where(workout: "Walk").empty?
      @walk_wkts = @user.workouts.where(workout: "Walk")
    end
    # binding.pry
    erb :"/users/index"
  end

  post '/signup' do

      if params[:username].empty? || params[:email].empty? || params[:password].empty?

        flash[:s_error] = "Username, Email & Password required "
           redirect "/signup"
       else
         @user = User.create(:username => params[:username], :email => params[:email].downcase, :password => params[:password])
         @user.save
         if  logged_in? || @user.save
         session[:user_id] = @user.id
         session[:email] = @user.email
         session[:username] = @user.username
         flash[:signup] = "Signed Up!"
         redirect '/landing'
       end
      end
  end



  post "/login" do
     @user = User.find_by(username: params[:username])
    #  binding.pry
    if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          session[:email] = @user.email
          session[:username] = @user.username
        flash[:notice] = "Logged In!"
        redirect "/landing"
    else
      flash[:l_error] = "Username & Password required "
        redirect "/login"
    end
  end


end
