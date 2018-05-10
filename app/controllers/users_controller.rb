require './config/environment'
require 'rack-flash'
 require 'sinatra/redirect_with_flash'

 register Sinatra::ActiveRecordExtension

class UsersController < ApplicationController

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


end
