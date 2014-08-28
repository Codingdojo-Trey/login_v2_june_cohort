class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in @user
      redirect_to user_path(@user)
  	else
  		#Adam's birthday gift
  		render :new
  	end
  end

  def show
    # this sets the current user quite easily!
    @current_user = current_user

    @user = User.find(params[:id])

    # EXAMPLE OF current_user? logic
    
    # if current_user? @user
    #   #admin stuff
    #   render :text => "you are the user"
    # else
    #   # regular stuff
    #   render :text => "you are not the user"
    # end
  end

  private
  	def user_params
  		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  	end
end
