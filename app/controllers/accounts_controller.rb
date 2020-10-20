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
	logger.debug "JVR: importing OFX file-> #{params}"
	
	ofx_data = params[:ofx_file]

	ofx = OfxParser::OfxParser.parse(ofx_data.read)
	
	tx_imported=0
	tx_auto_tagged=0
	imported_account=nil
	
	if ofx
	
		# read the attributes of this financial insitution from the ofx file
		ofx_org = ofx.sign_on.institute.name
		ofx_fi = ofx.sign_on.institute.id
	
		statement_transactions = nil
	
		# check if this is a credit card
		if ofx.credit_card
			logger.info 'credit card statement'
			begin
				statement_transactions = ofx.credit_card.statement.transactions
				ofx_account_id = ofx.credit_card.number	#get the account number
				ofx_account_type = "credit card"
				ofx_account_balance = ofx.credit_card.balance
			rescue
				logger.info 'line rescued'
			end
		end
		
		# check if this is a bank statement
		if ofx.bank_account
			logger.info 'bank statement'
			begin
				statement_transactions = ofx.bank_account.statement.transactions
				ofx_account_id = ofx.bank_account.number #get the account number
				ofx_account_type =ofx.bank_account.type #get the type of account
				ofx_account_balance = ofx.bank_account.balance
			rescue
				logger.info 'line rescued'
			end
		end
		
		# loop through each transaction in the file, and add it to the db
		if (statement_transactions)
		
			# check if the account we are importing to already exists in the db
			account=Account.where(:ofx_ACCTID=>ofx_account_id).first
			
			if (account)
				logger.info 'account from ' + ofx_org + ' already exists'
				account.last_import_date=Date.today
				account.balance = ofx_account_balance
				account.save
			else
				logger.info 'account from ' + ofx_org + ' does not exist and will be created'
				name = ofx_org.to_s + ' - ' + ofx_account_type.to_s
				account = Account.create(	:name=>name,
											:ofx_ORG=>ofx_org, :ofx_FI=>ofx_fi, :ofx_ACCTID=>ofx_account_id,
											:last_import_date=>Date.today,
											:balance=>ofx_account_balance)
			end			

			imported_account = account.name			
			
			statement_transactions.each do |t|
				unless Transaction.find_by_guid(t.fit_id)	# only add if it doesn't already exist in the db
					logger.info 'a transaction'
					tx_imported +=1
					tx=Transaction.new
					tx.payee = import_payee(t.payee)
					tx.amount = t.amount.to_f
					tx.date = t.date
					tx.account=account
					tx.guid = t.fit_id
					unless (tx.payee.last_tag.blank?)
						tx.tag_list=tx.payee.last_tag.split(/, /)
						tx_auto_tagged +=1
					end
					tx.save
				end
			end
		end
	end
	
	flash[:notice] = tx_imported.to_s + " transactions imported to " + imported_account + ". " + tx_auto_tagged.to_s + " auto tagged"	
	
	redirect_to :action=>:index
 end
 
 def import_payee (raw_name)
	
	# check if the payee already exists in the db
	payee=Payee.where(:name=>raw_name).first
	
	if (payee)
		logger.info 'payee ' + raw_name + ' already exists'
	else
		logger.info 'payee ' + raw_name + ' does not exist and will be created'
		payee = Payee.create(:name=>raw_name, :friendly_name=>raw_name )
	end	
	
	return payee
		
end
  
end
