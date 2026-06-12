class TransactionsController < ApplicationController
  def index
  
	unless session[:active_month]
		session[:active_month] = Date.today.month
	end
	
	unless session[:active_year]
		session[:active_year] = Date.today.year
	end

	if params[:date]
		# switch to use a new month
		session[:active_month] = params[:date][:month]
		session[:active_year]  = params[:date][:year]
		session[:untagged]     = params[:untagged] == '1'
	end

	@month    = session[:active_month]
	@year     = session[:active_year]
	@untagged = session[:untagged]

	# create a listing of all the transactions
	@start_date = Date.new(@year.to_i, @month.to_i, 1)
	@end_date = @start_date.end_of_month

	# build the list of transactions
	@txs = Transaction.where("date >= ? and date <= ?", @start_date, @end_date).order("date DESC")
	@txs = @txs.untagged if @untagged
	
  end

  def edit
    @tx = Transaction.find(params[:id])
  end

  def update
    tx = Transaction.find(params[:id])
    tx.update(transaction_params)
	
	p=tx.payee
	p.last_tag = tx.tag_list.to_s
	p.save
	
	respond_to do |format|

		format.html do
		  p.friendly_name = params[:payee][:friendly_name]
		  p.save

		  #go back to the register
		  redirect_to transactions_url 
		end

		format.json do
		  head :no_content
		end
	  
	 end
  end

  def destroy
	tx = Transaction.find(params[:id])
	p = tx.payee
	tx.destroy
	
	if p.transactions.count == 0
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
