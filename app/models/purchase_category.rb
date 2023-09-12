# frozen_string_literal: true

class PurchaseCategory < ApplicationRecord
  belongs_to :purchase
  belongs_to :category
end
