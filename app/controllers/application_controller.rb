class ApplicationController < ActionController::Base
 protect_from_forgery
	before_action :login_required
	
	def login_required
    if session[:user]
      return true
    end
    flash[:notice]='Please login to continue'
    session[:return_to]=request.fullpath
    redirect_to :controller => "user", :action => "login"
    return false 
  end
end
