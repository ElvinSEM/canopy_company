# ActiveAdmin.setup do |config|
#
#   # config.namespace :admin do |admin|
#   #   admin.build_controller do
#   #     layout "admin/vite_admin"
#   #   end
#   # end
#
#   config.view_factory.layout = "admin/vite_admin"
#
#
#   config.site_title = "Admin Panel"
#
#   config.authentication_method = :authenticate_admin_user!
#   config.current_user_method = :current_admin_user
#
#   config.logout_link_path = :destroy_admin_user_session_path
#   config.logout_link_method = :delete
#
#   config.comments = false
#   config.batch_actions = true
#
#   ActiveAdmin.application.register_stylesheet nil
#   ActiveAdmin.application.register_javascript nil
#
# end


# config/initializers/active_admin.rb

# Убедитесь, что эта настройка включена
ActiveAdmin.setup do |config|
  config.use_webpacker = true # Несмотря на название, это заставляет AA искать ассеты не только в Sprockets
end

# Модуль для перехвата вызовов хелперов
module ActiveAdminViteJS
  def stylesheet_pack_tag(*stylesheets, **options)
    vite_stylesheet_tag(*stylesheets, **options)
  end

  def javascript_pack_tag(*scripts, **options)
    vite_javascript_tag(*scripts, **options)
  end

  # Может потребоваться для иконки (favicon)
  def favicon_pack_tag(favicon)
    vite_asset_path(favicon)
  end
end

# Подключаем модуль к ViewHelpers, чтобы он работал на всех страницах,
# включая страницу входа в систему
ActiveAdmin::ViewHelpers.include ActiveAdminViteJS