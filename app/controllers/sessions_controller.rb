class SessionsController < ApplicationController
  def create
    if request.post?
      user = User.authenticate(params[:acc], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to :controller => :users, :action => :show, :id => session[:user_id] 
      else
        flash.now[:notice] = "Invalid account/password combination"
      end
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Logged out"
    redirect_to(:action => "create") 
  end
end
