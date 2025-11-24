# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Дополнительные валидации
  validates :email,
            presence: { message: "Email не может быть пустым" },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "Неверный формат email"
            }

  validates :password,
            presence: { message: "Пароль не может быть пустым" },
            length: {
              minimum: 6,
              message: "Пароль должен содержать минимум 6 символов"
            },
            on: :create
end