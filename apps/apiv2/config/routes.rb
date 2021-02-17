resources :meetings, only: [:index, :show]
resources :articles, only: [:index, :show]
get '/meetings/:meeting_id/comments', to: 'meetings/comments#index'
get '/meetings/:id/pastMeeting', to: 'meetings#past'
