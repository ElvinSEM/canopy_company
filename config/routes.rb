Rails.application.routes.draw do
  root 'leads#new' # Указываем, что корневой маршрут ведет на форму заявки
  resources :leads, only: [:new, :create] # Добавляем маршруты для LeadsController
end
