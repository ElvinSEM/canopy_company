# # frozen_string_literal: true
# ActiveAdmin.register_page "Dashboard" do
#   menu priority: 1, label: "📊 Панель управления"
#
#   content title: "Добро пожаловать, админ!" do
#     columns do
#       column do
#         panel "Статистика лидов" do
#           ul do
#             li "Новых лидов: #{Lead.where(status: 'Новая').count}"
#             li "В работе: #{Lead.where(status: 'В работе').count}"
#             li "Завершённых: #{Lead.where(status: 'Завершена').count}"
#           end
#         end
#       end
#
#       column do
#         panel "Последние лиды" do
#           table_for Lead.order(created_at: :desc).limit(5) do
#             column("Имя") { |lead| lead.name }
#             column("Телефон") { |lead| lead.phone }
#             column("Статус") { |lead| status_tag(lead.status, class: lead_status_class(lead.status)) }
#             column("Создан") { |lead| lead.created_at.strftime("%d-%m-%Y %H:%M") }
#             column("Действие") { |lead| link_to "Подробнее", admin_lead_path(lead) }
#           end
#         end
#       end
#     end
#   end
# end

# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 0, label: "📊 Главная"

  content title: "Главная панель" do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        h2 "Добро пожаловать в админ-панель Canopy Company!"
        para "Здесь вы можете управлять заявками с сайта."
      end
    end

    # Простая статистика
    columns do
      column do
        panel "Статистика лидов" do
          ul do
            li "Всего лидов: #{Lead.count}"
            li "Новых: #{Lead.where(status: 'новая').count}"
            li "В работе: #{Lead.where(status: 'в работе').count}"
            li "Обработано: #{Lead.where(status: 'обработана').count}"
          end
        end
      end

      column do
        panel "Последние лиды" do
          ul do
            Lead.order(created_at: :desc).limit(5).map do |lead|
              li do
                span link_to(lead.name, admin_lead_path(lead))
                span " - #{lead.phone}"
                span " (#{lead.status})", style: "color: #666; font-size: 0.9em;"
              end
            end
          end
        end
      end
    end
  end
end