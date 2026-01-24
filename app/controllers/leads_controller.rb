class LeadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @lead = Lead.new
    @company = Company.first
    respond_to do |format|
      format.html # обычный запрос
      format.js   # для AJAX запроса
    end
  end

  def create
    @lead = Lead.new(lead_params)
    @company = Company.first

    if @lead.save
      # Генерируем токен и сохраняем ссылку для приглашения
      telegram_invite_link = @lead.telegram_invite_link if @lead.respond_to?(:telegram_invite_link)
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
    # Используем новый стиль с .with()
    LeadMailer.with(
      lead: @lead,
      company_name: @company&.name || "Canopy Company"
    ).admin_notification.deliver_later
  rescue => e
    Rails.logger.error "Ошибка отправки письма администратору: #{e.message}"
  end

  def send_client_confirmation
    # Отправляем только если есть email
    return unless @lead.email.present?

    LeadMailer.with(
      lead: @lead,
      company_name: @company&.name || "Canopy Company"
    ).client_confirmation.deliver_later
  rescue => e
    Rails.logger.error "Ошибка отправки подтверждения клиенту: #{e.message}"
  end
end