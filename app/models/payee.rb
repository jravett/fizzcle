class Payee < ApplicationRecord

  #  t.string :name   // maps to <NAME> ofx
  #  t.string :friendly_name

  has_many :transactions

  # Find or create a Payee for an OFX import. Applies fuzzy matching first,
  # then falls back to an exact name match or a new record.
  def self.find_or_create_for_import(raw_name)
    # Check fuzzy rules first
    fuzzy_match = Fuzzy.all.find { |f| raw_name.start_with?(f.fuzzy_text) }
    if fuzzy_match
      return find_or_create_by(name: fuzzy_match.payee_name) do |p|
        p.friendly_name = fuzzy_match.payee_name
      end
    end

    find_or_create_by(name: raw_name) do |p|
      p.friendly_name = raw_name
    end
  end
end
