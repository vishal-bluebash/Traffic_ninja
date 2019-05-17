FROM ruby:2.4.4

MAINTAINER vishalgarg231@gmail.com

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /ninja

WORKDIR /ninja

COPY Gemfile /ninja/Gemfile

COPY Gemfile.lock /ninja/Gemfile.lock

ENV RAILS_ENV production

RUN echo bundle -v
RUN bundle install

COPY . /ninja

COPY config/docker_database.yml config/database.yml