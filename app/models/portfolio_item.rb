class PortfolioItem < ApplicationRecord
  belongs_to :company
  has_one_attached :photo
  validates :title, presence: true
  validates :description, presence: true
end

