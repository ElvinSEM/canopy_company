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

# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "📊 Панель управления"

  content title: "Добро пожаловать, админ!" do
    columns do
      column do
        panel "Статистика лидов" do
          ul do
            li "Новых лидов: #{Lead.where(status: 'Новая').count}"
            li "В работе: #{Lead.where(status: 'В работе').count}"
            li "Завершённых: #{Lead.where(status: 'Завершена').count}"
          end
        end
      end

      column do
        panel "Последние лиды" do
          table_for Lead.order(created_at: :desc).limit(5) do
            column("Имя") { |lead| lead.name }
            column("Телефон") { |lead| lead.phone }
            column("Статус") { |lead| status_tag(lead.status, class: lead_status_class(lead.status)) }
            column("Создан") { |lead| lead.created_at.strftime("%d-%m-%Y %H:%M") }
            column("Действие") { |lead| link_to "Подробнее", admin_lead_path(lead) }
          end
        end
      end
    end
  end
end
