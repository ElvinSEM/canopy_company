# ActiveAdmin.setup do |config|
#
#   config.site_title = "Canopy Company"
#
#   config.authentication_method = :authenticate_admin_user!
#
#   config.current_user_method = :current_admin_user
#
#   config.logout_link_path = :destroy_admin_user_session_path
#
#   config.batch_actions = true
#
#   config.filter_attributes = [:encrypted_password, :password, :password_confirmation]
#
#   config.localize_format = :long
#
# end


# config/initializers/active_admin.rb
ActiveAdmin.setup do |config|
  config.site_title = "Canopy Company - Админ панель"
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.logout_link_method = :delete

  # Упрощаем настройки
  config.comments = false
  config.batch_actions = true
  config.filter_attributes = [:encrypted_password, :password, :password_confirmation]
end