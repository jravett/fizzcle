class Transaction < ApplicationRecord
	belongs_to :account
	belongs_to :payee
	
	accepts_nested_attributes_for :payee
	
	acts_as_taggable_on :tags
end
