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
  after_create_commit :notify_about_new_lead
  after_create_commit :notify_admin_about_new_lead
  after_update_commit :notify_on_status_change, if: :saved_change_to_status?
  after_initialize :set_default_status, if: :new_record?
  before_create :generate_invite_token # Генерируем токен перед созданием

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

  def avatar_initials
    name.split.map(&:first).join.upcase
  end

  def avatar_color
    colors = ['#4299e1', '#667eea', '#9f7aea', '#ed64a6', '#f56565', '#ed8936', '#ecc94b', '#48bb78']
    colors[name.hash % colors.length]
  end

  def telegram_invite_link
    return unless invite_token.present?

    bot_username = ENV['TELEGRAM_BOT_USERNAME']
    "https://t.me/#{bot_username}?start=invite_#{id}_#{invite_token}"
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

  def notify_about_new_lead
    # Ставим задачу в очередь, а не выполняем сразу
    TelegramNotificationJob.perform_later(self.id)
  end

  def generate_invite_token
    # Генерируем криптографически безопасный уникальный токен
    self.invite_token = SecureRandom.urlsafe_base64(16)
  end

  # Подключен ли уже к Telegram?
  def telegram_connected?
    telegram_chat_id.present? && subscription_confirmed_at.present?
  end

  # Связываем с Telegram
  def connect_to_telegram!(chat_id, username = nil)
    update!(
      telegram_chat_id: chat_id,
      telegram_username: username,
      subscription_confirmed_at: Time.current,
      invite_token: nil # Очищаем токен после использования (опционально)
    )
  end

  # Проверяем, подписан ли на канал
  def subscribed_to_channel?
    subscribed_to_channel == true
  end
end