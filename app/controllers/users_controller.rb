class UsersController < ApplicationController

  def index
    @users = User.find(:all)
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
  end

end
