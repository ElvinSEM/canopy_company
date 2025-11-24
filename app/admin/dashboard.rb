# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 0, label: "Главная"

  content title: "Панель управления" do
    # Метод для статусов в Dashboard
    def lead_status_class(status)
      case status
      when 'Новая' then 'status-new'
      when 'В работе' then 'status-in-progress'
      when 'Завершена' then 'status-completed'
      else 'status-default'
      end
    end

    columns do
      column do
        panel "📊 Статистика лидов" do
          div class: "stats-grid" do
            div class: "stat-item" do
              h3 Lead.count
              p "Всего лидов"
            end
            div class: "stat-item" do
              h3 Lead.where(status: 'Новая').count
              p "Новые"
            end
            div class: "stat-item" do
              h3 Lead.where(status: 'В работе').count
              p "В работе"
            end
            div class: "stat-item" do
              h3 Lead.where(status: 'Завершена').count
              p "Завершено"
            end
          end
        end
      end

      column do
        panel "🕒 Последние лиды" do
          recent_leads = Lead.order(created_at: :desc).limit(5)

          if recent_leads.any?
            table_for recent_leads do
              column "Имя" do |lead|
                link_to lead.name, admin_lead_path(lead)
              end
              column "Телефон", :phone
              column "Статус" do |lead|
                status_tag(lead.status, class: lead_status_class(lead.status))
              end
              column "Дата" do |lead|
                I18n.l(lead.created_at, format: :short)
              end
            end
          else
            para "Пока нет лидов"
          end
        end
      end
    end
  end
end