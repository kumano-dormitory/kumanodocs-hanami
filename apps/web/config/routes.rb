# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'article#index'
get '/article/search', to: 'article#search', as: :search_article
resources :article do
  resource :lock, only: [:new, :create]
end
resources :meeting, only: [:index, :show]

get '/meeting/:meeting_id/block/:block_id/comment/edit', to: 'comment#edit', as: :edit_comment
patch '/meeting/:meeting_id/block/:block_id/comment/', to: 'comment#update', as: :comments
