# class CompaniesController < ApplicationController
#   before_action :set_company, only: [:show, :edit, :update]
#
#   def show
#     @portfolio_items = @company.portfolio_items.with_attached_photo
#   end
#
#   def edit
#   end
#
#   def update
#     if @company.update(company_params)
#       redirect_to root_path, notice: "Данные компании успешно обновлены."
#     else
#       render :edit
#     end
#   end
#
#   private
#
#   def set_company
#     @company = Company.first_or_create
#   end
#
#   def company_params
#     params.require(:company).permit(:name, :phone, :email, :description, :logo)
#   end
# end


class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update]
  # before_action :authenticate_admin!, only: [:edit, :update]

  # Публичная страница компании
  def show
    @portfolio_items = @company.portfolio_items.with_attached_photo
  end

  # Форма редактирования (только для администратора)
  def edit
    authenticate_admin_user!  # защита от обычных пользователей
  end

  # Обновление данных компании (логотип, контакты, описание)
  def update
    authenticate_admin_user!

    if @company.update(company_params)
      redirect_to company_path(@company), notice: "Данные компании успешно обновлены."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = Company.first_or_create
  end

  def company_params
    params.require(:company).permit(:name, :phone, :email, :description, :logo)
  end
  def authenticate_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "У вас нет доступа к этой странице."
    end
  end
end
