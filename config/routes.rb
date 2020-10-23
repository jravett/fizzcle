Rails.application.routes.draw do
  get 'report/tag'
  get 'report/year_tag'
  get 'report/monthly_summary'
  get 'transactions/index'
  get 'transactions/update'
  get 'transactions/destroy'
  get 'main/index'
  
  root 'main#index'
  
  resources :accounts
  resources :transactions
  resources :report

  
  get '/user/login' #, to: 'patients#show'
  post '/user/login', to: 'user#login'
  get '/user/logout', to: 'user#logout'
  post '/report/tag', to: 'report#tag'
  post 'report/year_tag', to: 'report#year_tag'
  post '/report/monthly_summary', to: 'report#monthly_summary'
  post '/accounts/upload', to: 'accounts#upload'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
