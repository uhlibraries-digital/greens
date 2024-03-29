FROM ruby:2.5.7

ENV APP_PATH=/greens-app

RUN apt-get update -q && apt-get install -y \
  build-essential \
  nodejs

RUN mkdir /greens-app
WORKDIR /greens-app

ADD Gemfile /greens-app/Gemfile
ADD Gemfile.lock /greens-app/Gemfile.lock

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN gem install bundler && bundle install
ADD . /greens-app/