# Rails.application.routes.draw do
#   # Настройка ActiveAdmin и Devise
#   devise_for :admin_users, ActiveAdmin::Devise.config
#   ActiveAdmin.routes(self)
#
#   # Главная страница – форма захвата лида
#   root "leads#new"
#
#   # Маршруты для заявок (лидов)
#   resources :leads, only: [:new, :create]
#
#   # Управление компаниями
#   resource :company, only: [:show, :edit, :update]
#   resources :companies, only: [:show, :edit, :update] do
#     resources :portfolio_items, except: [:show]  # Вложенные портфолио
#   end
# end




Rails.application.routes.draw do
  # ActiveAdmin + Devise
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  # Главная страница – форма захвата лида
  root "leads#new"

  # Лиды
  resources :leads, only: [:new, :create]

  # Единственная компания
  resource :company, only: [:show, :edit, :update]

  # Портфолио для одной компании
  resources :portfolio_items, except: [:show]

  namespace :api do
    namespace :v1 do
      resources :leads, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
