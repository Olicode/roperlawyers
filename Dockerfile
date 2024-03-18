# Use Ruby 2.7 as the base image
FROM ruby:2.7.4

ENV NODE_VERSION=18.12.0

# Install dependencies
# For a standard Rails app, you might need nodejs and yarn for JavaScript execution and asset compilation
# and default-libmysqlclient-dev if you are using MySQL
#RUN apt-get update -qq && apt-get install -y nodejs npm yarn default-libmysqlclient-dev

RUN gem update bundler
# Set the working directory inside the container to /myapp
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock from your app's root directory into /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Install gems
RUN bundle install

COPY package.json /myapp/package.json
COPY package-lock.json /myapp/package-lock.json


RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN npm install -g yarn
RUN yarn install


ENV NODE_OPTIONS=--openssl-legacy-provider

ENV MAILER_FROM=
ENV MAILER_TO=contactreceiver@yopmail.com
# Copy the rest of your app's code into /myapp
COPY . /myapp
# Expose the port your app runs on. Default Rails port is 3000
EXPOSE 3000

# Start the main process, which is the Rails server in this case
CMD ["rails", "server", "-b", "0.0.0.0"]
