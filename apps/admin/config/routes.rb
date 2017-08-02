# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/meeting/:id/articles/number/edit', to: 'article_number#edit'
patch '/meeting/:id/articles/number/', to: 'article_number#update'
get '/meeting/:id/articles/status/edit', to: 'article_status#edit'
patch '/meeting/:id/articles/status/', to: 'article_status#update'
