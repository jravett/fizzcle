class PayeesController < ApplicationController
  def index
	@payees = Payee.all
  end

  def edit
  end
  
  def update
    p = Payee.find(params[:id])
	logger.debug "JVR: saving this payee-> #{params}"
	
    p.friendly_name = params[:payee][:friendly_name]
    p.save
  end
  
end
