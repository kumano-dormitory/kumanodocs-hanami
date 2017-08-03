# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'meeting#index'
get '/meeting/:id/articles/number/edit', to: 'article_number#edit', as: :edit_article_number
patch '/meeting/:id/articles/number/', to: 'article_number#update', as: :update_article_number
get '/meeting/:id/articles/status/edit', to: 'article_status#edit', as: :edit_article_status
patch '/meeting/:id/articles/status/', to: 'article_status#update', as: :update_article_status
