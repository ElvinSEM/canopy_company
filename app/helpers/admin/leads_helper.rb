# module Admin
#   module LeadsHelper   # <- множественное число, чтобы совпадало с именем файла
#     def lead_status_class(status)
#       case status
#       when "Новая" then "status-new"
#       when "В работе" then "status-in-progress"
#       when "Завершена" then "status-completed"
#       else "status-default"
#       end
#     end
#   end
# end




# app/helpers/admin/leads_helper.rb
module Admin::LeadsHelper
  def lead_status_class(status)
    case status.to_s
    when 'new'
      'orange'
    when 'in_progress'
      'blue'
    when 'completed'
      'green'
    when 'rejected'
      'red'
    else
      'gray'
    end
  end
end