# app/mailers/lead_mailer.rb
class LeadMailer < ApplicationMailer
  default from: 'Elvin@canopycompany.com'

  def new_lead_notification
    # Данные теперь в params[:lead], НЕ в аргументе
    @lead = params[:lead]
    @company_name = params[:company_name] || "Canopy Company"

    mail(
      to: 'Elvin@canopycompany.com',
      subject: "🎯 Новая заявка с сайта: #{@lead.name}"
    )
  end

  def lead_status_updated
    @lead = params[:lead]
    return unless @lead.email.present?  # Не отправляем, если нет email

    mail(
      to: @lead.email,
      subject: "✅ Статус вашей заявки обновлен"
    )
  end
end