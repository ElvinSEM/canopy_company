# app/helpers/application_helper.rb
module ApplicationHelper
  # Определяем заголовок страницы
  def page_title
    return @page_title if @page_title.present?

    base_title = @company&.name || ENV["COMPANY_NAME"] || "ELVINCompany"

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
end