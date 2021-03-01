get '/meetings/:id/pastMeeting', to: 'meetings#past'
resources :meetings, only: [:index, :show] do
  resources :comments, only: [:index]
end
post '/meetings/:meeting_id/comments', to: 'meetings/comments#update'

resources :articles, only: [:index, :show]
post '/articles', to: 'articles#create'
post '/articles/:id', to: 'articles#update'
get '/articles/:id/checkLock', to: 'articles#check_lock'
post '/articles/:id/getLock', to: 'articles#get_lock'

get '/search', to: 'articles#search'
post '/login/getToken', to: 'login#token'

get '/gijiroku', to: 'gijiroku#index'
post '/gijiroku', to:  'gijiroku#update'
