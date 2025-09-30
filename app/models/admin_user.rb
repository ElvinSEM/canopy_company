class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Указываем, какие атрибуты доступны для поиска через Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "created_at", "updated_at"]
  end
end
