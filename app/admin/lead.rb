ActiveAdmin.register Lead do
  permit_params :name, :email, :phone, :status, :message
  
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :status
    column :created_at
    actions
  end
  
  filter :name
  filter :email
  filter :status
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :status
      f.input :message
    end
    f.actions
  end
end
