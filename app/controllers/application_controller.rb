class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # since all controllers inherit from this bad boy, we're going to define some nice methods to do 
  # some small login/authentication logic 

  def sign_in user
  	# takes the user object and sets session data using said object
  	session[:user_id] = user.id
  	self.current_user = user
  end

  def sign_out
  	session[:user_id] = nil
  	current_user = nil
  end

  # this method will return the current user
  def current_user
  	@current_user || User.find(session[:user_id]) if session[:user_id]
  end

  # this method will set the current user
  def current_user= user
  	@current_user = User.find(user.id)
  end

  # this is good to check if the user has admin priviliges or something along those lines 
  def current_user? user
  	user == self.current_user
  end


  def signed_in?
  	# !current_user.nil?
  	# non-double negative...what a dumb phrase
  	current_user.present?
  end

  def deny_access
  	flash[:notice] = "you are not authenticated enough to be here"  
  	redirect_to sign_in_path
  end

end

