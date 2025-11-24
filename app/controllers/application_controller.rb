# class ApplicationController < ActionController::Base
#   before_action :set_company
#
#   private
#
#   def set_company
#     @company = Company.first_or_create(
#       name: ENV["COMPANY_NAME"] || "ElvinCompany",
#       phone: ENV["COMPANY_PHONE"] || "+7 (123) 456-78-90",
#       email: ENV["COMPANY_EMAIL"] || "Elvin@canopycompany.com",
#       description: "Надежные навесы под ключ"
#     )
#   end
# end
# class ApplicationController < ActionController::Base
#   # На Rails 8 CSRF по умолчанию работает через actionpack
#   protect_from_forgery with: :exception
#
#   # Если Devise используется и в admin, и в обычной части — это важно
#   before_action :configure_permitted_parameters, if: :devise_controller?
#   before_action :check_admin_access
#
#   protected
#
#   # Разрешаем дополнительные поля в Devise, если понадобятся
#   def configure_permitted_parameters
#     devise_parameter_sanitizer.permit(:sign_up, keys: [])
#     devise_parameter_sanitizer.permit(:account_update, keys: [])
#   end
#
#   private
#
#   def check_admin_access
#     return unless admin_section?
#
#     # Дополнительные проверки для админ-разделов
#     unless admin_user_signed_in?
#       redirect_to main_app.root_path, alert: 'Доступ запрещен'
#     end
#   end
#
#   def admin_section?
#     controller_path.start_with?('admin/') ||
#       self.class.ancestors.include?(ActiveAdmin::BaseController)
#   end
# end





# class ApplicationController < ActionController::Base
#   # На Rails 8 CSRF по умолчанию работает через actionpack
#   protect_from_forgery with: :exception
#
#   # Если Devise используется и в admin, и в обычной части — это важно
#   before_action :configure_permitted_parameters, if: :devise_controller?
#   before_action :check_admin_access
#
#   protected

  # Разрешаем class ApplicationController < ActionController::Base
  #   # На Rails 8 CSRF по умолчанию работает через actionpack
  #   protect_from_forgery with: :exception
  #
  #   # Если Devise используется и в admin, и в обычной части — это важно
  #   before_action :configure_permitted_parameters, if: :devise_controller?
  #   before_action :check_admin_access
  #
  #   # Делаем метод доступным в хелперах
  #   helper_method :admin_section?
  #
  #   protected
  #
  #   # Разрешаем дополнительные поля в Devise, если понадобятся
  #   def configure_permitted_parameters
  #     devise_parameter_sanitizer.permit(:sign_up, keys: [])
  #     devise_parameter_sanitizer.permit(:account_update, keys: [])
  #   end
  #
  #   private
  #
  #   def check_admin_access
  #     return unless admin_section?
  #
  #     # Дополнительные проверки для админ-разделов
  #     unless admin_user_signed_in?
  #       redirect_to main_app.root_path, alert: 'Доступ запрещен'
  #     end
  #   end
  #
  #   def admin_section?
  #     # Простая проверка по URL пути
  #     request.path.start_with?('/admin')
  #   end
  # end
  # end


class ApplicationController < ActionController::Base
  # На Rails 8 CSRF по умолчанию работает через actionpack
  protect_from_forgery with: :exception

  # Если Devise используется и в admin, и в обычной части — это важно
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :check_admin_access

  # Делаем метод доступным в хелперах
  helper_method :admin_section?

  protected

  # Разрешаем дополнительные поля в Devise, если понадобятся
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
    devise_parameter_sanitizer.permit(:account_update, keys: [])
  end

  private

  def check_admin_access
    return unless admin_section?

    # Дополнительные проверки для админ-разделов
    unless admin_user_signed_in?
      redirect_to main_app.root_path, alert: 'Доступ запрещен'
    end
  end

  def admin_section?
    # Простая проверка по URL пути
    request.path.start_with?('/admin')
  end
end