Rails.application.routes.draw do

  root 'main#index'
  get  'main/index'

  # Accounts — only the actions that exist; upload is a custom collection action
  resources :accounts, only: [:index, :destroy] do
    collection do
      post :upload
    end
  end

  # Transactions — standard CRUD minus :new/:create (imported via OFX)
  resources :transactions, only: [:index, :edit, :update, :destroy]

  # Payees
  resources :payees, only: [:index, :edit, :update]

  # Authentication
  get  '/user/login',  to: 'user#login'
  post '/user/login',  to: 'user#login'
  get  '/user/logout', to: 'user#logout'

  # Reports — not a standard resource; each action accepts GET (form) and POST (results)
  get  '/report',                  to: 'report#index'
  get  '/report/monthly_summary',  to: 'report#monthly_summary'
  post '/report/monthly_summary',  to: 'report#monthly_summary'
  get  '/report/tag',              to: 'report#tag'
  post '/report/tag',              to: 'report#tag'
  get  '/report/year_tag',         to: 'report#year_tag'
  post '/report/year_tag',         to: 'report#year_tag'

end
