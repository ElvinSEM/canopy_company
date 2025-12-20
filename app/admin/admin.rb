ActiveAdmin.register Lead do
  menu label: "📋 Лиды", priority: 1

  permit_params :name, :email, :phone, :message, :status

  config.sort_order = 'created_at_desc'

  scope :all, default: true
  scope("📥 Новые")    { |scope| scope.where(status: 'Новая') }
  scope("⚡ В работе") { |scope| scope.where(status: 'В работе') }
  scope("✅ Завершены") { |scope| scope.where(status: 'Завершена') }

  filter :name
  filter :email
  filter :phone
  filter :status, as: :select, collection: ['Новая', 'В работе', 'Завершена']
  filter :created_at

  index title: "📋 Список лидов" do
    selectable_column
    id_column

    column "Клиент", :name do |lead|
      div class: "lead-name-cell" do
        div class: "lead-avatar" do
          lead.name.to_s.split.map(&:first).join.upcase
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

    column "Телефон", :phone do |lead|
      if lead.phone.present?
        div class: "lead-phone" do
          lead.phone
        end
      else
        span style: "color: #9ca3af; font-size: 13px;" do
          "не указан"
        end
      end
    end

    column "Сообщение", :message do |lead|
      if lead.message.present?
        div style: "max-width: 300px;" do
          truncate(lead.message, length: 80)
        end
      end
    end

    column "Статус", :status do |lead|
      case lead.status
      when "Новая"
        span class: "status-badge status-new" do
          lead.status
        end
      when "В работе"
        span class: "status-badge status-in-progress" do
          lead.status
        end
      when "Завершена"
        span class: "status-badge status-completed" do
          lead.status
        end
      else
        lead.status
      end
    end

    column "Создан", :created_at do |lead|
      div class: "time-ago" do
        span class: "time-icon" do "🕒" end
        time_ago_in_words(lead.created_at) + " назад"
      end
    end

    actions do |lead|
      div class: "action-buttons" do
        if lead.status == "Новая"
          link_to "Взять",
                  admin_lead_path(lead, lead: { status: "В работе" }),
                  method: :patch,
                  class: "action-btn btn-take",
                  data: { confirm: "Взять лид '#{lead.name}' в работу?" }
        elsif lead.status == "В работе"
          link_to "Завершить",
                  admin_lead_path(lead, lead: { status: "Завершена" }),
                  method: :patch,
                  class: "action-btn btn-complete",
                  data: { confirm: "Завершить лид '#{lead.name}'?" }
        end

        link_to "Просмотр",
                admin_lead_path(lead),
                class: "action-btn btn-view"

        link_to "Редакт.",
                edit_admin_lead_path(lead),
                class: "action-btn",
                style: "background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: white;"

        link_to "Удалить",
                admin_lead_path(lead),
                method: :delete,
                class: "action-btn",
                style: "background: linear-gradient(135deg, #ef4444, #dc2626); color: white;",
                data: { confirm: "Удалить лид '#{lead.name}'?" }
      end
    end
  end

  form do |f|
    f.inputs "Информация о лиде" do
      f.input :name, label: "Имя"
      f.input :email, label: "Email"
      f.input :phone, label: "Телефон"
      f.input :message, label: "Сообщение", input_html: { rows: 5 }
      f.input :status,
              label: "Статус",
              as: :select,
              collection: ['Новая', 'В работе', 'Завершена'],
              include_blank: false
    end
    f.actions do
      f.action :submit, label: "Сохранить лид"
      f.action :cancel, label: "Отмена", wrapper_html: { class: "cancel" }
    end
  end

  show do
    attributes_table do
      row :name
      row :email
      row :phone

      row :status do |lead|
        case lead.status
        when "Новая"
          span class: "status-badge status-new" do
            lead.status
          end
        when "В работе"
          span class: "status-badge status-in-progress" do
            lead.status
          end
        when "Завершена"
          span class: "status-badge status-completed" do
            lead.status
          end
        end
      end

      row :created_at
      row :updated_at
    end

    panel "📝 Сообщение" do
      div style: "background: #f9fafb; padding: 20px; border-radius: 10px; margin: 15px 0;" do
        para lead.message, style: "white-space: pre-wrap; font-size: 15px; line-height: 1.6;"
      end
    end

    active_admin_comments
  end

  # Батч-действия для массового изменения статуса
  batch_action :take_in_work do |ids|
    batch_action_collection.find(ids).each do |lead|
      lead.update(status: "В работе")
    end
    redirect_to collection_path, alert: "Выбранные лиды взяты в работу"
  end

  batch_action :complete do |ids|
    batch_action_collection.find(ids).each do |lead|
      lead.update(status: "Завершена")
    end
    redirect_to collection_path, alert: "Выбранные лиды завершены"
  end

  # Экспорт в CSV
  csv do
    column :id
    column :name
    column :email
    column :phone
    column :message
    column :status
    column :created_at
    column :updated_at
  end

  # Дополнительные кнопки действий в show
  action_item :edit, only: :show do
    link_to "✏️ Редактировать", edit_admin_lead_path(resource)
  end

  action_item :change_status, only: :show do
    case resource.status
    when "Новая"
      link_to "⚡ Взять в работу",
              admin_lead_path(resource, lead: { status: "В работе" }),
              method: :patch,
              data: { confirm: "Взять лид '#{resource.name}' в работу?" }
    when "В работе"
      link_to "✅ Завершить",
              admin_lead_path(resource, lead: { status: "Завершена" }),
              method: :patch,
              data: { confirm: "Завершить лид '#{resource.name}'?" }
    end
  end
end