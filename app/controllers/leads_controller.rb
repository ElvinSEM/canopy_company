class LeadsController < ApplicationController
  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    if @lead.save
      redirect_to root_path, notice: "Спасибо за вашу заявку! Мы свяжемся с вами в ближайшее время."
    else
      render :new
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :message)
  end
end