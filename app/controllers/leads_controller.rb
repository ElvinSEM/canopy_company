# # class LeadsController < ApplicationController
# #   def new
# #     @lead = Lead.new
# #   end
# #
# #   # def create
# #   #   @lead = Lead.new(lead_params)
# #   #
# #   #   if @lead.save
# #   #     attach_files if params[:lead][:files].present?
# #   #     respond_to do |format|
# #   #       format.html { redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время." }
# #   #       format.json { render json: { message: "Заявка успешно отправлена!" }, status: :created }
# #   #     end
# #   #   else
# #   #     respond_to do |format|
# #   #       format.html { render :new }
# #   #       format.json { render json: { error: @lead.errors.full_messages.join(", ") }, status: :unprocessable_entity }
# #   #     end
# #   #   end
# #   # end
# #
# #   def create
# #     Rails.logger.debug "Параметры: #{params[:lead].inspect}" # Логируем входящие данные
# #     @lead = Lead.new(lead_params)
# #
# #     if @lead.save
# #       Rails.logger.debug "PARAMS: #{params.inspect}"
# #
# #       attach_files if params[:lead][:files].present?
# #       Rails.logger.debug "Файлы после attach_files: #{@lead.files.attached?}" # Проверяем прикрепление
# #       respond_to do |format|
# #         format.html { redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время." }
# #         format.json { render json: { message: "Заявка успешно отправлена!" }, status: :created }
# #       end
# #     else
# #       Rails.logger.debug "Ошибки сохранения: #{@lead.errors.full_messages}"
# #       respond_to do |format|
# #         format.html { render :new }
# #         format.json { render json: { error: @lead.errors.full_messages.join(", ") }, status: :unprocessable_entity }
# #       end
# #     end
# #   end
# #
# #
# #
# #   private
# #
# #   def lead_params
# #     params.require(:lead).permit(:name, :email, :phone, :message)
# #   end
# # end
#
#
# class LeadsController < ApplicationController
#   def new
#     @lead = Lead.new
#   end
#
#   def create
#     @lead = Lead.new(lead_params)
#
#     if @lead.save
#       LeadMailer.new_lead(@lead).deliver_later
#       respond_to do |format|
#         format.html { redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время." }
#         format.json { render json: { message: "Заявка успешно отправлена!" }, status: :created }
#       end
#     else
#       respond_to do |format|
#         format.html { render :new }
#         format.json { render json: { error: @lead.errors.full_messages.join(", ") }, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   private
#
#   def lead_params
#     params.require(:lead).permit(:name, :email, :phone, :message)
#   end
# end

class LeadsController < ApplicationController
  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      # Загружаем файлы (если есть)
      @lead.files.attach(params[:lead][:files]) if params[:lead][:files].present?

      # Отправляем уведомление админу
      LeadMailer.new_lead(@lead).deliver_later

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
        format.json { render json: { error: @lead.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :message, files: [])
  end
end
