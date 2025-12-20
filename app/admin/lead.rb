ActiveAdmin.register Lead do
  permit_params :name, :email, :phone, :message, :status

  # ====== MEMBER ACTIONS ======
  member_action :set_in_progress, method: :patch do
    resource.update!(status: "В работе")
    redirect_back fallback_location: admin_dashboard_path
  end

  member_action :set_completed, method: :patch do
    resource.update!(status: "Завершена")
    redirect_back fallback_location: admin_dashboard_path
  end
end
