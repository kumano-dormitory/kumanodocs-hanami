resources :meetings, only: [:index, :show] do
  resources :comments, only: [:index]
end
resources :articles, only: [:index, :show]

get '/search', to: 'articles#search'
get '/login/getToken', to: 'login#token'
