resources :meetings, only: [:index, :show]
resources :articles, only: [:index, :show]

get '/search', to: 'articles#search'
