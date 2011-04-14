class ApplicationController < ActionController::Base
  layout "users"
  session :session_key => '_takenote_session_id'
  	
  helper :all 
	
#	protect_from_forgery

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end
		
end
