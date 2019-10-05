root to: 'user#top'

resources :user
resources :session, only: [:new, :create, :destroy]

get '/user/top', to: 'user#top'
get '/logout', to: 'session#destroy', as: :logout
get '/log', to: 'log#index', as: :logs
get '/db', to: 'db#index', as: :dbs
post '/db', to: 'db#run', as: :dbs
