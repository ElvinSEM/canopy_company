Rails.application.routes.draw do
  # # ActiveAdmin + Devise
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  # Главная страница – форма захвата лида
  root "leads#new"
  get '/leads', to: redirect('/admin/leads')
  post '/telegram_webhook', to: 'telegram/webhooks#callback'
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
