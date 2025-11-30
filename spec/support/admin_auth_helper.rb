# spec/support/active_admin_auth_helper.rb
module ActiveAdminAuthHelper
  def login_as_admin(admin_user = nil)
    admin_user ||= create(:admin_user)

    # Для Active Admin используем прямой POST запрос к сессии
    post admin_user_session_path, params: {
      admin_user: {
        email: admin_user.email,
        password: admin_user.password
      }
    }

    follow_redirect!
  end

  def sign_in_admin(admin_user = nil)
    admin_user ||= create(:admin_user)

    # Альтернативный способ - установка Warden
    page.driver.browser.set_cookie("admin_user_id=#{admin_user.id}")
    page.driver.browser.set_cookie("admin_user_credentials=#{admin_user.encrypted_password}")
  end
end

RSpec.configure do |config|
  config.include ActiveAdminAuthHelper, type: :feature
end