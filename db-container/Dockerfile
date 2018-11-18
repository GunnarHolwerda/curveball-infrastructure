FROM ubuntu:xenial
WORKDIR /usr/local/src/postgrest

COPY config/local.conf .
RUN apt-get update
RUN apt-get install wget xz-utils libpq-dev -y
RUN wget https://github.com/PostgREST/postgrest/releases/download/v5.1.0/postgrest-v5.1.0-ubuntu.tar.xz
RUN tar xfJ postgrest-v5.1.0-ubuntu.tar.xz
EXPOSE 3000
CMD ["./postgrest", "local.conf"]