class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.authenticate(params[:email], params[:password])
  	if user
  		sign_in user
  		redirect_to user_path(user)
  	else # bad login
  		flash[:errors] = "your login was terrible...fatality"
  		redirect_to new_session_path 
  	end
  end

  def destroy
  	sign_out
  	redirect_to signin_path
  end
end
