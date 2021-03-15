get '/articles/search', to: 'articles#search'
resources :meetings, only: [:index, :show]
resources :articles, only: [:index, :show]
get '/articles/:id/pdf', to: 'articles#pdf'
get '/meetings/:meeting_id/comments', to: 'meetings/comments#index'
get '/meetings/:id/pastMeeting', to: 'meetings#past'

options '/*', to: ->(env) {
  [200, {
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Methods" => 'POST, GET, OPTIONS',
    "Access-Control-Allow-Headers" => 'authorization'
  }, ['']]
}
get '/gijirokus', to: 'gijirokus#index'
get '/gijirokus/:id', to: 'gijirokus#show'
get '/documents', to: 'documents#index'
get '/documents/:id', to: 'documents#show'
post '/login/getToken', to: 'login#token'
