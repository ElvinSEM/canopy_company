module Admin
  module LeadsHelper   # <- множественное число, чтобы совпадало с именем файла
    def lead_status_class(status)
      case status
      when "Новая" then "status-new"
      when "В работе" then "status-in-progress"
      when "Завершена" then "status-completed"
      else "status-default"
      end
    end
  end
end
