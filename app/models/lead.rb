# app/models/lead.rb
class Lead < ApplicationRecord
  # Простые валидации
  validates :name, presence: true
  validates :phone, presence: true
  validates :message, presence: true

  # Устанавливаем статус по умолчанию
  after_initialize :set_default_status, if: :new_record?

  # Разрешенные атрибуты для Ransack (поиск в Active Admin)
  def self.ransackable_attributes(auth_object = nil)
    %w[name email phone status created_at updated_at]
  end

  # Разрешенные ассоциации для Ransack
  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Метод для определения класса статуса
  def status_class
    case status
    when 'Новая' then 'status-new'
    when 'В работе' then 'status-in-progress'
    when 'Завершена' then 'status-completed'
    else 'status-default'
    end
  end

  private

  def set_default_status
    self.status ||= 'Новая'
  end
end