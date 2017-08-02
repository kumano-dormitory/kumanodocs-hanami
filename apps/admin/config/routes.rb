# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/admin/meeting/:id/prepare/arrange', to: 'prepare#arrange'
get '/admin/meeting/:id/prepare/select', to: 'prepare#select'
