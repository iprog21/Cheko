# Dotenv::Railtie.load # or require 'dotenv/rails-now' -> These enable the dotenv-rails gem during initialization.
require "ruby/openai"

OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
end