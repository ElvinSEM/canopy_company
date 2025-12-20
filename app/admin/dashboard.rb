ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "📊 Дашборд"

  content title: "Панель управления" do

    # Метод для получения инициалов имени
    def name_initials(name)
      name.to_s.split.map(&:first).join.upcase
    end

    # Метод для цветовых классов статусов
    def status_badge(status)
      case status.to_s
      when "Новая" then "status-badge status-new"
      when "В работе" then "status-badge status-in-progress"
      when "Завершена" then "status-badge status-completed"
      else "status-badge"
      end
    end

    # ===== БЛОК СТАТИСТИКИ =====
    div class: "dashboard-container" do
      # Карточки статистики
      div class: "stats-grid" do
        # Всего лидов
        div class: "stat-card total" do
          h3 class: "stat-number" do
            Lead.count
          end
          p class: "stat-label" do
            "Всего лидов"
          end
          span class: "stat-trend trend-up" do
            "↑ +#{Lead.where('created_at >= ?', 7.days.ago).count} за неделю"
          end
        end

        # Новые лиды
        div class: "stat-card new" do
          h3 class: "stat-number" do
            Lead.where(status: "Новая").count
          end
          p class: "stat-label" do
            "Новые лиды"
          end
          span class: "stat-trend trend-up" do
            "⚠️ Требуют внимания"
          end
        end

        # В работе
        div class: "stat-card in-progress" do
          h3 class: "stat-number" do
            Lead.where(status: "В работе").count
          end
          p class: "stat-label" do
            "В работе"
          end
          span class: "stat-trend" do
            "Среднее время: 3.5 дня"
          end
        end

        # Завершены
        div class: "stat-card completed" do
          h3 class: "stat-number" do
            Lead.where(status: "Завершена").count
          end
          p class: "stat-label" do
            "Завершены"
          end
          span class: "stat-trend trend-up" do
            "Конверсия: #{Lead.where(status: "Завершена").count > 0 ? ((Lead.where(status: "Завершена").count.to_f / Lead.count) * 100).round(1) : 0}%"
          end
        end
      end

      # ===== НОВЫЕ ЛИДЫ (Требуют внимания) =====
      panel "📥 Новые лиды — требуют обработки", class: "dashboard-panel" do
        new_leads = Lead.where(status: "Новая").order(created_at: :desc).limit(15)

        if new_leads.any?
          table class: "leads-table" do
            thead do
              tr do
                th "Клиент"
                th "Контакты"
                th "Статус"
                th "Создан"
                th "Действия"
              end
            end

            tbody do
              new_leads.each do |lead|
                tr do
                  # Колонка Клиент
                  td do
                    div class: "lead-name-cell" do
                      div class: "lead-avatar" do
                        name_initials(lead.name)
                      end
                      div class: "lead-info" do
                        div class: "lead-name" do
                          lead.name
                        end
                        div class: "lead-email" do
                          lead.email.presence || "Email не указан"
                        end
                      end
                    end
                  end

                  # Колонка Контакты
                  td do
                    if lead.phone.present?
                      div class: "lead-phone" do
                        lead.phone
                      end
                    else
                      span style: "color: #9ca3af; font-size: 13px;" do
                        "Телефон не указан"
                      end
                    end
                  end

                  # Колонка Статус
                  td do
                    span class: status_badge(lead.status) do
                      lead.status
                    end
                  end

                  # Колонка Создан
                  td do
                    div class: "time-ago" do
                      span class: "time-icon" do "🕒" end
                      time_ago_in_words(lead.created_at) + " назад"
                    end
                  end

                  # Колонка Действия
                  td do
                    div class: "action-buttons" do
                      link_to "Взять в работу",
                              admin_lead_path(lead, lead: { status: "В работе" }),
                              method: :patch,
                              class: "action-btn btn-take",
                              data: { confirm: "Взять лид '#{lead.name}' в работу?" }

                      link_to "Просмотр",
                              admin_lead_path(lead),
                              class: "action-btn btn-view"
                    end
                  end
                end
              end
            end
          end
        else
          div class: "empty-state" do
            div class: "empty-icon" do
              "✅"
            end
            h3 "Все новые лиды обработаны"
            p "Отличная работа! Новые лиды отсутствуют."
          end
        end
      end

      # ===== ЛИДЫ В РАБОТЕ =====
      panel "⚡ Лиды в работе", class: "dashboard-panel" do
        in_progress_leads = Lead.where(status: "В работе").order(updated_at: :desc).limit(15)

        if in_progress_leads.any?
          table class: "leads-table" do
            thead do
              tr do
                th "Клиент"
                th "Контакты"
                th "В работе"
                th "Обновлен"
                th "Действия"
              end
            end

            tbody do
              in_progress_leads.each do |lead|
                tr do
                  # Колонка Клиент
                  td do
                    div class: "lead-name-cell" do
                      div class: "lead-avatar" do
                        name_initials(lead.name)
                      end
                      div class: "lead-info" do
                        div class: "lead-name" do
                          lead.name
                        end
                        div class: "lead-email" do
                          lead.email.presence || "Email не указан"
                        end
                      end
                    end
                  end

                  # Колонка Контакты
                  td do
                    if lead.phone.present?
                      div class: "lead-phone" do
                        lead.phone
                      end
                    else
                      span style: "color: #9ca3af; font-size: 13px;" do
                        "Телефон не указан"
                      end
                    end
                  end

                  # Колонка В работе
                  td do
                    div class: "time-ago" do
                      span class: "time-icon" do "⏱️" end
                      time_ago_in_words(lead.updated_at) + ""
                    end
                  end

                  # Колонка Обновлен
                  td do
                    div class: "time-ago" do
                      span class: "time-icon" do "🔄" end
                      time_ago_in_words(lead.updated_at) + " назад"
                    end
                  end

                  # Колонка Действия
                  td do
                    div class: "action-buttons" do
                      link_to "Завершить",
                              admin_lead_path(lead, lead: { status: "Завершена" }),
                              method: :patch,
                              class: "action-btn btn-complete",
                              data: { confirm: "Завершить лид '#{lead.name}'?" }

                      link_to "Позвонить",
                              "tel:#{lead.phone}",
                              class: "action-btn btn-take" if lead.phone.present?
                    end
                  end
                end
              end
            end
          end
        else
          div class: "empty-state" do
            div class: "empty-icon" do
              "📋"
            end
            h3 "Нет активных лидов"
            p "Все лиды либо новые, либо завершены."
          end
        end
      end

      # ===== БЫСТРЫЕ ДЕЙСТВИЯ =====
      div class: "quick-actions-panel" do
        h3 class: "quick-actions-title" do
          "⚡ Быстрые действия"
        end

        div class: "quick-actions-grid" do
          link_to new_admin_lead_path, class: "quick-action-btn" do
            span class: "quick-action-icon" do "➕" end
            span "Создать лид"
          end

          link_to admin_leads_path, class: "quick-action-btn" do
            span class: "quick-action-icon" do "📋" end
            span "Все лиды"
          end

          link_to admin_leads_path(q: { status_eq: "Новая" }), class: "quick-action-btn" do
            span class: "quick-action-icon" do "📥" end
            span "Новые"
          end

          link_to admin_leads_path(q: { status_eq: "В работе" }), class: "quick-action-btn" do
            span class: "quick-action-icon" do "⚡" end
            span "В работе"
          end

          link_to admin_leads_path(format: :csv), class: "quick-action-btn" do
            span class: "quick-action-icon" do "📊" end
            span "Экспорт CSV"
          end

          link_to "#", onclick: "window.location.reload()", class: "quick-action-btn" do
            span class: "quick-action-icon" do "🔄" end
            span "Обновить"
          end
        end
      end
    end
  end
end