# # app/models/lead.rb
# class Lead < ApplicationRecord
#
#   after_create_commit :notify_admin_about_new_lead
#   after_update_commit :notify_on_status_change, if: :saved_change_to_status?
#
#   # Простые валидации
#   validates :name, presence: true
#   # validates :phone, presence: true
#   # validates :message, presence: true
#   # Устанавливаем статус по умолчанию
#   after_initialize :set_default_status, if: :new_record?
#
#   # Разрешенные атрибуты для Ransack (поиск в Active Admin)
#   def self.ransackable_attributes(auth_object = nil)
#     %w[name email phone status created_at updated_at]
#   end
#
#   # Разрешенные ассоциации для Ransack
#   def self.ransackable_associations(auth_object = nil)
#     []
#   end
#
#   # Метод для определения класса статуса
#   def status_class
#     case status
#     when 'Новая' then 'status-new'
#     when 'В работе' then 'status-in-progress'
#     when 'Завершена' then 'status-completed'
#     else 'status-default'
#     end
#   end
#
#   private
#
#   def notify_admin_about_new_lead
#     LeadNotificationService.notify_new_lead(self)
#   end
#
#   def notify_on_status_change
#     LeadNotificationService.notify_status_update(self)
#   end
#
#   def set_default_status
#     self.status ||= 'Новая'
#   end
# end


# app/models/lead.rb
# class Lead < ApplicationRecord
#
#   after_create :send_new_lead_notification
#   after_update :send_status_update_notification, if: :saved_change_to_status?
#
#   STATUSES = ['Новая', 'В работе', 'Завершена'].freeze
#
#   validates :name, presence: true
#   validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
#   validates :status, inclusion: { in: STATUSES }
#
#   # Scopes
#   scope :new_leads, -> { where(status: 'Новая') }
#   scope :in_progress, -> { where(status: 'В работе') }
#   scope :completed, -> { where(status: 'Завершена') }
#   scope :recent, ->(limit = 5) { order(created_at: :desc).limit(limit) }
#
#   # Разрешенные ассоциации для Ransack
#     def self.ransackable_associations(auth_object = nil)
#       []
#     end
#
#   # Методы экземпляра
#   def status_class
#     case status
#     when 'Новая' then 'status-new'
#     when 'В работе' then 'status-in-progress'
#     when 'Завершена' then 'status-completed'
#     else 'status-default'
#     end
#   end
#
#   # Методы класса
#   def self.status_counts
#     group(:status).count
#   end
#
#   # Callbacks
#   after_initialize :set_default_status, if: :new_record?
#
#   private
#
#   def set_default_status
#     self.status ||= 'Новая'
#   end
#
#   def send_new_lead_notification
#     LeadNotificationService.notify_new_lead(self)
#   end
#
#   def send_status_update_notification
#     LeadNotificationService.notify_status_update(self)
#   end
# end



# app/models/lead.rb
class Lead < ApplicationRecord
  # Константа для статусов
  STATUSES = ['Новая', 'В работе', 'Завершена'].freeze

  # ===== ВАЛИДАЦИИ =====
  validates :name, presence: { message: "Имя не может быть пустым" }
  # validates :email,
  #           presence: { message: "Email не может быть пустым" },
  #           format: {
  #             with: URI::MailTo::EMAIL_REGEXP,
  #             message: "Неверный формат email"
  #           }
  validates :status,
            inclusion: {
              in: STATUSES,
              message: "Статус должен быть одним из: #{STATUSES.join(', ')}"
            }

  # Phone и message - опциональные
  # validates :phone, allow_blank: true
  # validates :message, allow_blank: true

  # ===== CALLBACKS =====
  after_create_commit :notify_admin_about_new_lead
  after_update_commit :notify_on_status_change, if: :saved_change_to_status?
  after_initialize :set_default_status, if: :new_record?

  # ===== SCOPES =====
  scope :new_leads, -> { where(status: 'Новая') }
  scope :in_progress, -> { where(status: 'В работе') }
  scope :completed, -> { where(status: 'Завершена') }
  scope :recent, ->(limit = 5) { order(created_at: :desc).limit(limit) }

  # ===== CLASS METHODS =====
  def self.status_counts
    group(:status).count
  end

  # Разрешенные атрибуты для Ransack (поиск в Active Admin)
  def self.ransackable_attributes(auth_object = nil)
    %w[name email phone status created_at updated_at]
  end

  # Разрешенные ассоциации для Ransack
  def self.ransackable_associations(auth_object = nil)
    []
  end

  # ===== INSTANCE METHODS =====
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

  def notify_admin_about_new_lead
    LeadNotificationService.notify_new_lead(self)
  end

  def notify_on_status_change
    LeadNotificationService.notify_status_update(self)
  end

  def set_default_status
    self.status ||= 'Новая'
  end
end