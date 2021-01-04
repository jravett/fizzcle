class Fuzzy < ApplicationRecord
  validates :fuzzy_text, uniqueness: true
end
