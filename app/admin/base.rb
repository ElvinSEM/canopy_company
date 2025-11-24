module Admin
  class BaseController < ActionController::Base
    layout "admin/vite_admin"

    before_action :authenticate_admin_user!
  end
end
