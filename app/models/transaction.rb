class Transaction < ApplicationRecord
	belongs_to :account
	belongs_to :payee
	
	accepts_nested_attributes_for :payee
	
	acts_as_taggable_on :tags

	scope :untagged, -> {
		joins("LEFT OUTER JOIN taggings ON taggings.taggable_id = transactions.id
		       AND taggings.taggable_type = 'Transaction'
		       AND taggings.context = 'tags'")
		.where("taggings.id IS NULL")
	}
end
