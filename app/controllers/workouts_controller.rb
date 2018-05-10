require './config/environment'
require 'rack-flash'
 require 'sinatra/redirect_with_flash'

 register Sinatra::ActiveRecordExtension

class WorkoutsController < ApplicationController

  get '/workouts/:id' do
  # shows users single workout
    @workout = Workout.find(params[:id])

   if session[:user_id] == @workout.user_id

     @user = User.find(session[:user_id])
   erb :"users/show"
  elsif logged_in? && session[:user_id] != @workout.user_id
   @user = User.find(@workout.user_id)
   erb :"users/show"
  else
    redirect '/login'
  end
  end

end
