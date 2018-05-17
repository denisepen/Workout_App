require './config/environment'
require 'rack-flash'
 require 'sinatra/redirect_with_flash'

 register Sinatra::ActiveRecordExtension

class WorkoutsController < ApplicationController

  get '/workouts/new' do
    @workouts = Workout.all
    erb :'/workouts/new'
  end

  get '/workouts/:id/edit' do
   #  binding.pry
  if logged_in?
    @user = User.find(session[:user_id])
    @workout = Workout.find(params[:id])
    @user.save
    if @user.id == @workout.user_id

    erb :"/workouts/edit"
  else
    flash[:not_user] = "You can't edit another user's workout!"
    redirect '/users/workouts'
  end
 else
  redirect '/login'
 end
 end

 get '/workouts/workouts' do
    @user = User.find(session[:user_id])
   erb :"/workouts/index"
 end

  get '/workouts/:id' do
  # shows users single workout
    @workout = Workout.find(params[:id])

   if session[:user_id] == @workout.user_id

     @user = User.find(session[:user_id])
   erb :"users/show"
  elsif logged_in? && session[:user_id] != @workout.user_id
   @user = User.find(@workout.user_id)
  #
   erb :"users/show"
  else
    redirect '/login'
  end
  end



  get '/workouts/show' do
    #shows a users single workout
    @user = User.find(session[:user_id])
    @workout = Workout.find(params[:id])
    erb :"users/show"
  end


  patch '/workouts/:id' do
  #route to edit a single workout
   # raise params.inspect
   if logged_in?
    @workout=Workout.find(params[:id])
      if !params[:workout].empty?
        @workout.update(workout: params[:workout], date: params[:date], duration: params[:duration], comment: params[:comment], mileage: params[:mileage])

       session[:workout] = params[:workout]
       @user = User.find(session[:user_id])
       @user.id = @workout.user_id
       @workout.save
       flash[:updated] = "Your workout has been updated!"
       redirect "/workouts/#{@workout.id}"
     else
       redirect "/workouts/#{@workout.id}/edit"

     end

   end
 end

 post '/workouts/show' do
   #new workout created & displayed with this route
     # binding.pry
   @user = User.find(session[:user_id])
   if params[:workout].empty? && params[:new_workout].empty?
     redirect "/workouts/new"
   else
     if params[:new_workout].empty?
     @workout = Workout.new(date: params[:date], workout: params[:workout].capitalize, duration: params[:duration], comment: params[:comment], mileage: params[:mileage])
     else
   @workout = Workout.new(date: params[:date], workout: params[:new_workout].chomp.capitalize, duration: params[:duration], comment: params[:comment], mileage: params[:mileage])
   end
     @workout.save
     @user.workouts << @workout
   erb :"/users/show"
   end
 end

 delete '/workouts/:id/delete' do

     @workout =Workout.find_by_id(params[:id])
     # binding.pry
    if  @workout.user_id == session[:user_id] && logged_in?
      @workout.delete
     redirect '/users/workouts'
   else
     flash[:not_user] = "You can't edit another user's workout!"
    redirect '/users/workouts'
 end
 end


end
