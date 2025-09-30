# ActiveAdmin.register Lead do
#   permit_params :name, :email, :phone, :message, :status
#
#   index do
#     selectable_column
#     id_column
#     column :name
#     column :email
#     column :phone
#     column :status
#     column :created_at
#     actions
#   end
#
#   show do
#     attributes_table do
#       row :id
#       row :name
#       row :email
#       row :phone
#       row :message
#       row :status
#       row :created_at
#       row :updated_at
#     end
#   end
#
#   form do |f|
#     f.inputs "Данные лида" do
#       f.input :name
#       f.input :email
#       f.input :phone
#       f.input :message
#       f.input :status, as: :select, collection: ["Новая", "В работе", "Завершена"]
#     end
#     f.actions
#   end
# end
ActiveAdmin.register Lead do
  permit_params :name, :email, :phone, :message, :status
end
