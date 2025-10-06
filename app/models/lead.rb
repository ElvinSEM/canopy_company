class Lead < ApplicationRecord
  has_many_attached :files

  validates :name, presence: true
  # validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, length: { minimum: 10, maximum: 15 }
  validates :message, presence: true
  # validates :status, presence: true, inclusion: { in: ["Новая", "В работе", "Завершена"] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "phone", "email", "status", "created_at"]
  end
end
