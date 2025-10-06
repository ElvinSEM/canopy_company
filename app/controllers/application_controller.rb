class ApplicationController < ActionController::Base
  before_action :set_company

  private

  def set_company
    @company = Company.first_or_create(
      name: ENV["COMPANY_NAME"] || "ElvinCompany",
      phone: ENV["COMPANY_PHONE"] || "+7 (123) 456-78-90",
      email: ENV["COMPANY_EMAIL"] || "Elvin@canopycompany.com",
      description: "Надежные навесы под ключ"
    )
  end
end
