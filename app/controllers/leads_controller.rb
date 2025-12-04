# class LeadsController < ApplicationController
#   def new
#     @lead = Lead.new
#     @company = Company.first_or_create
#   end
#
#   def create
#     @lead = Lead.new(lead_params)
#
#     if @lead.save
#       # Если есть файлы — прикрепляем
#       @lead.files.attach(params[:lead][:files]) if params[:lead][:files].present?
#
#       # # Отправляем письмо
#       # LeadMailer.new_lead(@lead).deliver_later if defined?(LeadMailer)
#       # Отправляем письмо администратору
#       send_admin_notification
#
#       # Отправляем подтверждение клиенту (если указан email)
#       send_client_confirmation
#       respond_to do |format|
#         format.html do
#           redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время."
#         end
#         format.json do
#           render json: { message: "Заявка успешно отправлена!", lead_id: @lead.id }, status: :created
#         end
#       end
#     else
#       respond_to do |format|
#         format.html { render :new, status: :unprocessable_entity }
#         format.json { render json: { error: @lead.errors.full_messages.join(", ") }, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   private
#
#   def lead_params
#     params.require(:lead).permit(:name, :email, :phone, :message, files: [])
#   end
# end



# app/controllers/leads_controller.rb
class LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @lead = Lead.new
    @company = Company.first
  end

  def create
    @lead = Lead.new(lead_params)
    @company = Company.first

    if @lead.save
      # Отправляем письмо администратору
      send_admin_notification

      # Отправляем подтверждение клиенту (если указан email)
      send_client_confirmation

      # Если запрос пришел из модалки (AJAX или нет)
      if request.xhr? || params[:modal] == 'true'
        # Возвращаем JSON для AJAX
        render json: {
          success: true,
          message: 'Спасибо! Ваша заявка принята.'
        }
      else
        # Стандартный редирект для обычной формы
        redirect_to root_path,
                    notice: 'Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.'
      end
    else
      if request.xhr? || params[:modal] == 'true'
        # Возвращаем ошибки для AJAX
        render json: {
          success: false,
          errors: @lead.errors.full_messages
        }, status: :unprocessable_entity
      else
        # Стандартный рендер для обычной формы
        flash.now[:alert] = 'Пожалуйста, исправьте ошибки в форме.'
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :message)
  end

  def send_admin_notification
    if defined?(LeadMailer) && LeadMailer.respond_to?(:new_lead)
      LeadMailer.new_lead(@lead).deliver_later
    else
      Rails.logger.warn "LeadMailer.new_lead не доступен. Письмо не отправлено."
    end
  rescue => e
    Rails.logger.error "Ошибка отправки письма администратору: #{e.message}"
  end

  def send_client_confirmation
    if @lead.email.present? && defined?(LeadMailer) && LeadMailer.respond_to?(:lead_notification)
      LeadMailer.lead_notification(@lead).deliver_later
    end
  rescue => e
    Rails.logger.error "Ошибка отправки подтверждения клиенту: #{e.message}"
  end
end