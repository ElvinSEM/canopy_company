ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "📊 Дашборд"

  content title: "Панель управления" do
    # Метод для цветовых классов статусов
    def status_badge(status)
      case status
      when "Новая" then "status-new"
      when "В работе" then "status-in-progress"
      when "Завершена" then "status-completed"
      else "status-default"
      end
    end

    columns do
      column do
        panel "📈 Статистика лидов" do
          div class: "stats-grid" do
            # Карточки статистики
            div class: "stat-card" do
              h3 Lead.count
              p "Всего лидов"
            end

            div class: "stat-card" do
              h3 Lead.where(status: "Новая").count
              p "Новые"
            end

            div class: "stat-card" do
              h3 Lead.where(status: "В работе").count
              p "В работе"
            end

            div class: "stat-card" do
              h3 Lead.where(status: "Завершена").count
              p "Завершены"
            end
          end
        end
      end

      column do
        panel "📊 Распределение по статусам" do
          data = Lead.group(:status).count
          total_leads = Lead.count # Добавляем переменную с общим количеством

          if data.any?
            ul do
              data.each do |status, count|
                # Используем total_leads вместо total
                percentage = total_leads > 0 ? (count.to_f / total_leads * 100).round(1) : 0
                li do
                  span status || "Без статуса"
                  span "#{count} (#{percentage}%)", class: "float-right"
                end
              end
            end
          else
            para "Нет данных"
          end
        end
      end
    end

    columns do
      column do
        panel "🕒 Последние лиды" do
          recent_leads = Lead.order(created_at: :desc).limit(10)

          if recent_leads.any?
            table_for recent_leads do
              column "Имя" do |lead|
                link_to lead.name, admin_lead_path(lead)
              end
              column "Email", :email
              column "Телефон", :phone
              column "Статус" do |lead|
                status_tag lead.status, class: status_badge(lead.status)
              end
              column "Создан" do |lead|
                l(lead.created_at, format: :short)
              end
            end
          else
            para "Пока нет лидов"
          end
        end
      end

      column do
        panel "📅 Активность по дням" do
          # Лиды за последние 7 дней
          days_data = {}
          6.downto(0) do |i|
            date = i.days.ago.to_date
            days_data[date] = Lead.where(created_at: date.beginning_of_day..date.end_of_day).count
          end

          if days_data.values.sum > 0
            ul do
              days_data.each do |date, count|
                li do
                  span l(date, format: :short)
                  span "#{count} лид(ов)", class: "float-right"
                end
              end
            end
          else
            para "Нет активности за последние 7 дней"
          end
        end
      end
    end

    # Быстрые действия
    panel "⚡ Быстрые действия" do
      div class: "quick-actions" do
        span link_to "➕ Создать новый лид", new_admin_lead_path, class: "button"
        span link_to "📋 Все лиды", admin_leads_path, class: "button"
        span link_to "📤 Экспорт в CSV", admin_leads_path(format: :csv), class: "button"
      end
    end
  end
end