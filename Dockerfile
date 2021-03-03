FROM ruby:2.6.5
ARG HOMEDIR=/usr/src/bionic/
# Use volume as bundle cache so gems install faster
ENV BUNDLE_PATH /gems
WORKDIR $HOMEDIR
COPY Gemfile* $HOMEDIR
RUN bundle install
EXPOSE 3000
# Copy the rest of the app into /usr/src/tooly
COPY . .
# Create user to avoid running as root
RUN adduser --uid 1905 tom
RUN chown -R tom:tom .
USER tom
