class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to root_path, notice: "Данные компании успешно обновлены."
    else
      render :edit
    end
  end

  private

  def set_company
    @company = Company.first_or_create
  end

  def company_params
    params.require(:company).permit(:name, :phone, :email, :description, :logo)
  end
end
