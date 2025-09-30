ActiveAdmin.register Lead do
  controller do
    helper Admin::LeadsHelper
  end

  permit_params :name, :email, :phone, :message, :status

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column "Статус", :status do |lead|
      status_tag(lead.status, class: lead_status_class(lead.status))
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :phone
      row :message
      row "Статус" do |lead|
        status_tag(lead.status, class: lead_status_class(lead.status))
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Данные лида" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :message
      f.input :status, as: :select, collection: ["Новая", "В работе", "Завершена"]
    end
    f.actions
  end
end
