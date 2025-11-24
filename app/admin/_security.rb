# app/admin/security.rb
ActiveAdmin.setup do |config|
  # Настройка аутентификации
  config.authentication_method = :authenticate_admin_user!

  # Настройка авторизации
  # config.authorization_adapter = ActiveAdmin::PunditAdapter

  # Текущий пользователь
  config.current_user_method = :current_admin_user

  # Логаут
  config.logout_link_path = :destroy_admin_user_session_path
  config.logout_link_method = :delete

  # Заголовок
  config.site_title = "Canopy Company Admin"
  config.site_title_link = "/admin"
end