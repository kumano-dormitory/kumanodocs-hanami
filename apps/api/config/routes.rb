get '/meetings/:id/pastMeeting', to: 'meetings#past'
resources :meetings, only: [:index, :show] do
  resources :comments, only: [:index]
end
resources :articles, only: [:index, :show]

get '/search', to: 'articles#search'
post '/login/getToken', to: 'login#token'

get '/gijiroku', to: 'gijiroku#index'
post '/gijiroku', to:  'gijiroku#update'
