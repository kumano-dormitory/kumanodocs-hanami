# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'article#index'
# ドキュメント表示
get '/article/doc', to: 'article#doc', as: :document
get '/article/search', to: 'article#search', as: :search_article
resources :article do
  resource :lock, only: [:new, :create]
end
resources :meeting, only: [:index, :show]
resources :table, only: [:new, :create, :edit, :update, :destroy]

get '/meeting/:meeting_id/block/:block_id/comment/edit', to: 'comment#edit', as: :edit_comment
patch '/meeting/:meeting_id/block/:block_id/comment/', to: 'comment#update', as: :comments

get '/article/:article_id/table/:table_id/lock/new', to: 'article/lock#new', as: :new_article_lock_for_table
post '/article/:article_id/table/:table_id/lock', to: 'article/lock#create', as: :article_lock_for_table

get '/meeting/:id/download', to: 'meeting#download', as: :download_meeting

# 議事録チャット
get '/comment/:comment_id/message/new', to: 'comment/message#new', as: :new_comment_message
post '/comment/:comment_id/message', to: 'comment/message#create', as: :comment_messages
delete '/comment/message/:id', to: 'comment/message#destroy', as: :comment_message
