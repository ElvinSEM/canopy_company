# app/helpers/application_helper.rb
module ApplicationHelper
  # Определяем заголовок страницы
  def page_title
    return @page_title if @page_title.present?

    base_title = company_name

    if admin_section?
      "#{base_title} - Админ-панель"
    else
      base_title
    end
  end

  # Проверяем, находимся ли мы в админ-разделе
  def admin_section?
    # Простая проверка по URL пути - самый надежный способ
    request.path.start_with?('/admin')
  end

  # CSS классы для body
  def body_classes
    classes = []
    classes << "min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 font-sans antialiased"
    classes << "admin-section" if admin_section?
    classes << "page-#{controller_name}"
    classes << "action-#{action_name}"
    classes.join(' ')
  end

  # CSS классы для main
  def main_classes
    admin_section? ? "min-h-screen" : "min-h-screen flex flex-col"
  end

  # Data controllers для Stimulus
  def body_data_controllers
    controllers = []
    controllers << "smooth-scroll" unless admin_section?
    controllers << "navigation" unless admin_section?
    controllers.join(" ")
  end

  # ==================== МЕТОДЫ ДЛЯ КОМПАНИИ ====================

  # Текущая компания (кэшируем запрос)
  def current_company
    @current_company ||= Company.first
  end

  # Название компании
  def company_name
    return @company_name if defined?(@company_name) && @company_name.present?

    @company_name = if current_company&.name.present?
                      current_company.name
                    elsif ENV["COMPANY_NAME"].present?
                      ENV["COMPANY_NAME"]
                    else
                      "ELVINCompany"
                    end
  end

  # URL логотипа компании
  def company_logo_url
    return @company_logo_url if defined?(@company_logo_url)

    @company_logo_url = if current_company&.logo&.attached?
                          # Используем лого из Active Storage
                          url_for(current_company.logo)
                        else
                          # Дефолтное лого
                          vite_asset_path('images/default_logo.png')
                        end
  end

  # Инициали для fallback логотипа
  def company_logo_fallback
    company_name[0..1].upcase
  end

  # Проверяем есть ли логотип
  def has_company_logo?
    current_company&.logo&.attached?
  end

  # Альтернативный текст для логотипа
  def company_logo_alt
    "Логотип #{company_name}"
  end
end