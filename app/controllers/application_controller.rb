class ApplicationController < ActionController::Base
  before_action :set_company

  private

  def set_company
    @company = Company.first_or_create
  end
end

