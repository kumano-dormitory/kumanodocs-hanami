# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/meeting/:id/articles/number/edit', to: 'number#edit'
patch '/meeting/:id/articles/number/update', to: 'number#update'
get '/meeting/:id/articles/status/edit', to: 'status#edit'
patch '/meeting/:id/articles/number/update', to: 'status#update'
