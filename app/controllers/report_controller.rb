class ReportController < ApplicationController

  def index
  end
  
  def monthly_summary
  
  	if request.post?
			@month = params[:date][:month]
			@year = params[:date][:year]
			logger.info 'using given month ' + @month.to_s
			logger.info 'using given year ' + @year.to_s
		else
			logger.info 'defaulting to current month and year...'
			@month=Date.today.month
			@year=Date.today.year
		end
			
		@start_date = Date.new(@year.to_i, @month.to_i, 1)
		@end_date = @start_date.end_of_month
				
		@txs = Transaction.where(:date=> (@start_date)..(@end_date))
		
		@tag_amounts = Hash.new
		
		# loop through every transaction
		@txs.each do |tx|
			tags = tx.tag_list
			tags.each do |tg|
				if @tag_amounts[tg]
					@tag_amounts[tg] += tx.amount
				else
					@tag_amounts[tg] = tx.amount
				end
			end
		end
		
		# sort by amount
		@tag_amounts.sort { |l, r| l[1]<=>r[1] }
		
		@title = Date::MONTHNAMES[@month.to_i].to_s + " " + @year.to_s
	end
  
  def tag
	if request.post?
		@month = params[:date][:month]
		@year = params[:date][:year]
			
		@start_date = Date.new(@year.to_i, @month.to_i, 1)
		@end_date = @start_date.end_of_month

		@tag_name = params[:tag_name]
		
		logger.debug "JVR: Finding transactions for #{@tag_name} between #{@start_date} and #{@end_date}..."
		
		@txs = Transaction.tagged_with(@tag_name).where( {:date=>(@start_date)..(@end_date)} )
		
		@sum=0
		@txs.each {|t| @sum += t.amount}
	else
		@month=Date.today.month
		@year=Date.today.year
		@start_date = Date.new(@year, @month.to_i, 1)
	end
  end
  
  def year_tag
  
	if request.post?
		@year = params[:date][:year]
			
		@start_date = Date.new(@year.to_i, 1, 1)
		@end_date = @start_date.end_of_year

		@tag_name = params[:tag_name]
		@txs = Transaction.tagged_with(@tag_name).where( {:date=>(@start_date)..(@end_date)} )
		
		@count=@txs.count
		
		@sum=0
		@txs.each {|t| @sum += t.amount}
	else
		@year=Date.today.year
		@start_date = Date.new(@year, 1, 1)
	end

  end
  
end
 
