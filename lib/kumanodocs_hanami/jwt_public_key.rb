if (ENV['HANAMI_ENV'] == 'development' || ENV['HANAMI_ENV'] == 'test')
  KUMANODOCS_AUTH_TOKEN_PKEY = ENV['KUMANODOCS_AUTH_TOKEN_PKEY']
elsif (ENV['HANAMI_ENV'] == 'production')
  # TODO: change following line for production
  KUMANODOCS_AUTH_TOKEN_PKEY = ""
end
