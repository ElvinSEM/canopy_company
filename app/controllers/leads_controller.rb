class LeadsController < ApplicationController
  def new
    @lead = Lead.new
    @company = Company.first_or_create
  end

  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      # Если есть файлы — прикрепляем
      @lead.files.attach(params[:lead][:files]) if params[:lead][:files].present?

      # Отправляем письмо
      LeadMailer.new_lead(@lead).deliver_later if defined?(LeadMailer)

      respond_to do |format|
        format.html do
          redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время."
        end
        format.json do
          render json: { message: "Заявка успешно отправлена!", lead_id: @lead.id }, status: :created
        end
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: @lead.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :message, files: [])
  end
end
