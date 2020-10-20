class UserController < ApplicationController

	layout "user"
	skip_before_action :login_required


  def login
    if request.post?
    	if session[:user] = User.authenticate(params[:login], params[:password])
        	flash[:notice]  = "Login successful!"
					redirect_to :controller => 'main', :action => 'index'
			else
       		flash[:notice] = "Login unsuccessfull"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:notice] = 'Logged out'
    redirect_to :action => 'login'
  end
end
