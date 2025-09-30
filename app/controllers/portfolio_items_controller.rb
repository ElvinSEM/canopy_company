# class PortfolioItemsController < ApplicationController
#   before_action :set_company
#   before_action :set_portfolio_item, only: [:edit, :update, :destroy]
#
#   def index
#     @portfolio_items = @company.portfolio_items
#   end
#
#   def new
#     @portfolio_item = @company.portfolio_items.new
#   end
#
#   def create
#     @portfolio_item = @company.portfolio_items.new(portfolio_item_params)
#     if @portfolio_item.save
#       redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно создан."
#     else
#       render :new
#     end
#   end
#
#   def edit
#   end
#
#   def update
#     if @portfolio_item.update(portfolio_item_params)
#       redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно обновлен."
#     else
#       render :edit
#     end
#   end
#
#   def destroy
#     @portfolio_item.destroy
#     redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно удален."
#   end
#
#   private
#
#   def set_company
#     @company = Company.first_or_create
#   end
#
#   def set_portfolio_item
#     @portfolio_item = @company.portfolio_items.find(params[:id])
#   end
#
#   def portfolio_item_params
#     params.require(:portfolio_item).permit(:title, :description, :photo)
#   end
# end


class PortfolioItemsController < ApplicationController
  before_action :set_company
  before_action :set_portfolio_item, only: [:edit, :update, :destroy]

  def index
    @portfolio_items = @company.portfolio_items
  end

  def new
    @portfolio_item = @company.portfolio_items.new
  end

  def create
    @portfolio_item = @company.portfolio_items.new(portfolio_item_params)
    if @portfolio_item.save
      redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно создан."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @portfolio_item.update(portfolio_item_params)
      redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно обновлен."
    else
      render :edit
    end
  end

  def destroy
    @portfolio_item.destroy
    redirect_to company_portfolio_items_path(@company), notice: "Элемент портфолио успешно удален."
  end

  private

  def set_company
    @company = Company.first_or_create
  end

  def set_portfolio_item
    @portfolio_item = @company.portfolio_items.find(params[:id])
  end

  def portfolio_item_params
    params.require(:portfolio_item).permit(:title, :description, :photo)
  end
end
