class PayeesController < ApplicationController
  def index
	# see https://stackoverflow.com/questions/16996618/rails-order-by-results-count-of-has-many-association
	# this doesn't return payees with 0 transactions
	@payees = Payee
		.joins(:transactions)
		.group(:id)
		.order('COUNT(transactions.id) DESC')
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
