# app/admin/lead.rb
ActiveAdmin.register Lead do
  # ===== КОНФИГУРАЦИЯ =====
  menu label: "Лиды", priority: 1
  permit_params :name, :email, :phone, :message, :status

  # ===== ДЕЙСТВИЯ =====
  actions :all

  # ===== ФИЛЬТРЫ =====
  filter :name
  filter :email
  filter :phone
  filter :status, as: :select, collection: ['Новая', 'В работе', 'Завершена']
  filter :created_at

  # ===== ИНДЕКСНАЯ СТРАНИЦА =====
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone

    column :status do |lead|
      status_tag(lead.status, class: lead.status_class)
    end

    column :created_at
    actions
  end

  # ===== СТРАНИЦА ПОКАЗА =====
  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :phone
      row :message
      row :status
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  # ===== ФОРМА РЕДАКТИРОВАНИЯ =====
  form do |f|
    f.inputs "Данные лида" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :message, input_html: { rows: 4 }
    end

    f.inputs "Статус" do
      f.input :status, as: :select, collection: ['Новая', 'В работе', 'Завершена']
    end

    f.actions
  end
end