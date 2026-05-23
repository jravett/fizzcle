class UserController < ApplicationController

	layout "user"
	skip_before_action :login_required


  def login
    if request.post?
      user = User.authenticate(params[:login], params[:password])
      if user
        session[:user_id] = user.id
        flash[:notice] = "Login successful!"
        redirect_to :controller => 'main', :action => 'index'
      else
        flash[:notice] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to :action => 'login'
  end
end
