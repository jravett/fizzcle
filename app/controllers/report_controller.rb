class ReportController < ApplicationController

  def index
  end

  def monthly_summary
    if request.post?
      @month = params[:date][:month]
      @year  = params[:date][:year]
    else
      @month = Date.today.month
      @year  = Date.today.year
    end

    @start_date = Date.new(@year.to_i, @month.to_i, 1)
    @end_date   = @start_date.end_of_month

    @txs = Transaction.where(date: @start_date..@end_date)

    @tag_amounts = Hash.new

    @txs.each do |tx|
      tx.tag_list.each do |tg|
        @tag_amounts[tg] = (@tag_amounts[tg] || 0) + tx.amount
      end
    end

    # sort by amount ascending
    @tag_amounts = @tag_amounts.sort_by { |_, v| v }.to_h

    @title = "#{Date::MONTHNAMES[@month.to_i]} #{@year}"
  end

  def tag
    if request.post?
      @month = params[:date][:month]
      @year  = params[:date][:year]

      @start_date = Date.new(@year.to_i, @month.to_i, 1)
      @end_date   = @start_date.end_of_month

      @tag_name = params[:tag_name]
      @txs = Transaction.tagged_with(@tag_name).where(date: @start_date..@end_date)

      @sum = 0
      @txs.each { |t| @sum += t.amount }
    else
      @month      = Date.today.month
      @year       = Date.today.year
      @start_date = Date.new(@year, @month, 1)
    end
  end

  def year_tag
    if request.post?
      @year = params[:date][:year]

      @start_date = Date.new(@year.to_i, 1, 1)
      @end_date   = @start_date.end_of_year

      @tag_name = params[:tag_name]
      @txs      = Transaction.tagged_with(@tag_name).where(date: @start_date..@end_date)

      @count = @txs.count
      @sum   = 0
      @txs.each { |t| @sum += t.amount }
    else
      @year       = Date.today.year
      @start_date = Date.new(@year, 1, 1)
    end
  end

end
