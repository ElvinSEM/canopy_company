# class AdminUser < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   # Указываем, какие атрибуты доступны для поиска через Ransack
#   def self.ransackable_attributes(auth_object = nil)
#     ["id", "email", "created_at", "updated_at"]
#   end
# end



# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  def active_for_authentication?
    true
  end
end