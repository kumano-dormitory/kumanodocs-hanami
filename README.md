# Kumanodocs-Hanami

## Setup

Before setup, install Docker.

```shell-session
$ ./config/database_up.sh
$ bundle install --path vendor/bin
$ bundle exec hanami db prepare
$ bundle exec hanami server
$ bundle exec rake seed
```

And then, open [http://localhost:2300](http://localhost:2300).