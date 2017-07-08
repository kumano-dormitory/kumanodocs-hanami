sudo docker run --rm -v /var/lib/postgresql/data -e POSTGRES_USER=kd -e POSTGRES_PASSWORD=kd -p 5432:5432 --name kumanodocs_postgres -d postgres:9.6-alpine

