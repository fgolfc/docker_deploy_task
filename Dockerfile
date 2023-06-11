# テキストのバージョンであるRuby3.0.1に揃える
FROM ruby:3.0.1

ENV RAILS_ENV=production

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /still-plains-78980
WORKDIR /still-plains-78980
COPY Gemfile /still-plains-78980/Gemfile
COPY Gemfile.lock /still-plains-78980/Gemfile.lock
RUN gem update --system 3.3.20 && bundle install
COPY . /still-plains-78980

# コンテナ起動時に毎回実行する
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
 
# rails s　実行.
CMD ["rails", "server", "-b", "0.0.0.0"]