class AccountsController < ApplicationController

  def index
    @accounts = Account.all
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_path
  end

  def upload
    ofx_data = params[:ofx_file]
    ofx = OfxParser::OfxParser.parse(ofx_data.read)

    tx_imported = 0
    tx_auto_tagged = 0
    imported_account = nil

    if ofx

      ofx_org = ofx.sign_on.institute.name
      ofx_fi  = ofx.sign_on.institute.id

      statement_transactions = nil

      if ofx.credit_card
        begin
          statement_transactions = ofx.credit_card.statement.transactions
          ofx_account_id      = ofx.credit_card.number
          ofx_account_type    = "credit card"
          ofx_account_balance = ofx.credit_card.balance
        rescue StandardError => e
          logger.error "Error reading credit card statement: #{e.message}"
        end
      end

      if ofx.bank_account
        begin
          statement_transactions = ofx.bank_account.statement.transactions
          ofx_account_id      = ofx.bank_account.number
          ofx_account_type    = ofx.bank_account.type
          ofx_account_balance = ofx.bank_account.balance
        rescue StandardError => e
          logger.error "Error reading bank statement: #{e.message}"
        end
      end

      if statement_transactions

        account = Account.where(ofx_ACCTID: ofx_account_id).first

        if account
          account.last_import_date = Date.today
          account.balance = ofx_account_balance
          account.save
        else
          name = "#{ofx_org} - #{ofx_account_type}"
          account = Account.create(
            name: name,
            ofx_ORG: ofx_org, ofx_FI: ofx_fi, ofx_ACCTID: ofx_account_id,
            last_import_date: Date.today,
            balance: ofx_account_balance
          )
        end

        imported_account = account.name

        statement_transactions.each do |t|
          next if Transaction.find_by_guid(t.fit_id)

          tx         = Transaction.new
          tx.payee   = Payee.find_or_create_for_import(t.payee)
          tx.amount  = t.amount.to_f
          tx.date    = t.date
          tx.account = account
          tx.guid    = t.fit_id

          unless tx.payee.last_tag.blank?
            tx.tag_list = tx.payee.last_tag.split(/, /)
            tx_auto_tagged += 1
          end

          tx.save
          tx_imported += 1
        end
      end
    end

    flash[:notice] = "#{tx_imported} transactions imported to #{imported_account}. #{tx_auto_tagged} auto tagged"
    redirect_to action: :index
  end

end
