class PayeesController < ApplicationController
  def index
    @payees = Payee
      .joins(:transactions)
      .select('payees.*, COUNT(transactions.id) AS transactions_count')
      .group(:id)
      .order('transactions_count DESC')
  end

  def edit
  end

  def update
    p = Payee.find(params[:id])
    p.friendly_name = params[:payee][:friendly_name]
    p.save
  end
  
end
