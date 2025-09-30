class Company < ApplicationRecord
  has_one_attached :logo
  has_many :portfolio_items, dependent: :destroy
  accepts_nested_attributes_for :portfolio_items, allow_destroy: true
end
