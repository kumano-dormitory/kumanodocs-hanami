# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'article#top'
# ドキュメント表示
get '/article/doc', to: 'article#doc', as: :document
get '/article/search', to: 'article#search', as: :search_article
get '/article/diff', to: 'article#diff', as: :diff_article
get '/article/top', to: 'article#top'
resources :article do
  resource :lock, only: [:new, :create]
end
resources :meeting, only: [:index, :show]
resources :table, only: [:new, :create, :edit, :update, :destroy]
resource :login, only: [:show, :create]

get '/gijiroku/content', to: 'gijiroku#content', as: :content_gijiroku
get '/gijiroku/:id/delete', to: 'gijiroku#destroy', as: :destroy_gijiroku
resources :gijiroku, only: [:index, :show, :new, :create, :edit, :update]

get '/meeting/:meeting_id/block/:block_id/comment/edit', to: 'comment#edit', as: :edit_comment
patch '/meeting/:meeting_id/block/:block_id/comment/', to: 'comment#update', as: :comments
get '/meeting/:meeting_id/comment', to: 'comment#index', as: :select_block_comments

get '/article/:article_id/table/:table_id/lock/new', to: 'article/lock#new', as: :new_article_lock_for_table
post '/article/:article_id/table/:table_id/lock', to: 'article/lock#create', as: :article_lock_for_table

get '/meeting/:id/download', to: 'meeting#download', as: :download_meeting

# 議事録チャット
get '/comment/:comment_id/message/new', to: 'comment/message#new', as: :new_comment_message
post '/comment/:comment_id/message', to: 'comment/message#create', as: :comment_messages
delete '/comment/message/:id', to: 'comment/message#destroy', as: :comment_message

# Error page
get '/error/:id', to: 'error#show', as: :error

get '/about', to: 'funny#about', as: :about
