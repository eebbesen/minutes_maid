FROM ruby:2.5.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install bundler -v 2.0.1
RUN mkdir /minutes_maid
WORKDIR /minutes_maid
COPY Gemfile /minutes_maid/Gemfile
COPY Gemfile.lock /minutes_maid/Gemfile.lock
RUN bundle install
COPY . /minutes_maid

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
