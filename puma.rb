threads 0, 16
port 2300
environment "production"
rackup 'config.ru'

bind "unix:///tmp/sockets/puma.sock"

