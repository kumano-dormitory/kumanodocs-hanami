# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'meeting#top'
resources :meeting do
  resources :article do
    resources :table, only: [:new, :create, :edit, :update, :destroy]
  end
end
resources :sessions, only: [:new, :create, :destroy]
get '/logout', to: 'sessions#destroy', as: :logout # aタグのリンクからログアウトできるように定義

get '/meeting/:id/articles/number/edit', to: 'article_number#edit', as: :edit_article_number
patch '/meeting/:id/articles/number/', to: 'article_number#update', as: :article_number
get '/meeting/:id/articles/status/edit', to: 'article_status#edit', as: :edit_article_status
patch '/meeting/:id/articles/status/', to: 'article_status#update', as: :article_status

get '/article/:article_id/block/:block_id/comment/edit', to: 'meeting/article/comment#edit', as: :edit_comment
patch '/article/:article_id/block/:block_id/comment/', to: 'meeting/article/comment#update', as: :comment

get '/article/:article_id/comment/:comment_id/message/new', to: 'message#new', as: :new_message
post '/article/:article_id/comment/:comment_id/message', to: 'message#create', as: :messages
get '/article/:article_id/comment/:comment_id/message/:id/edit', to: 'message#edit', as: :edit_message
patch '/article/:article_id/comment/:comment_id/message/:id', to: 'message#update', as: :message
delete '/article/:article_id/comment/:comment_id/message/:id', to: 'message#destroy', as: :message

# pdfをダウンロードするページ
get '/meeting/:id/download', to: 'meeting#download', as: :download_meeting
