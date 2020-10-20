class TransactionsController < ApplicationController
  def index
  
 #   @txs = Transaction.all
	
	unless session[:active_month]
		session[:active_month] = Date.today.month
	end
	
	unless session[:active_year]
		session[:active_year] = Date.today.year
	end

	if params[:date]
		# switch to use a new month
		m = params[:date][:month]
		y = params[:date][:year]
		session[:active_month] = m
		session[:active_year]=y
		logger.info 'switching to month # ' + m.to_s
	end

	@month=session[:active_month]
	@year=session[:active_year]
	
	
	logger.info 'using month # ' + @month.to_s
	logger.info 'using year  # ' + @year.to_s
	
	# create a listing of all the transactions
	@start_date = Date.new(@year.to_i, @month.to_i, 1)
	@end_date = @start_date.end_of_month

	# build the list of transactions
	@txs = Transaction.where("date >= ? and date <= ?", @start_date, @end_date).order("date DESC")
	
  end

  def edit
  	#find the correct transaction to edit
	@tx = Transaction.find(params[:id])
	logger.debug "JVR: editing this transaction-> #{@tx.attributes.inspect}"
	#pass to the view for editing...
  end
  
  def update
  
  	tx = Transaction.find(params[:id])
	logger.debug "JVR: saving this transaction-> #{params}"
	logger.debug "JVR: saving this transaction-> #{transaction_params}"
	
	tx.update(transaction_params)
	
	respond_to do |format|	
	
	  format.html do
		p=tx.payee
		p.friendly_name = params[:payee][:friendly_name]
		p.save
		#go back to the register
		redirect_to transactions_url 
	  end
	  
	  format.json { head :no_content }
	  
	 end
  end

  def destroy
	tx = Transaction.find(params[:id])
	
	p=tx.payee
	
	logger.debug "JVR: Destroying transaction ID #{tx.id}..."
	tx.destroy
	
	if p.transactions.count==0
		logger.debug "JVR: Also destroying payee #{p.name} because it no longer has any transactions"
		p.destroy
	end
	
	#go back to the register
	redirect_to transactions_url 
  end
  
  private
  def transaction_params
    params.require(:transaction).permit(:date, :amount, :tag_list)
  end
  
end
