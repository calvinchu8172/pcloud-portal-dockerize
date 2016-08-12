# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
require 'simplecov'
SimpleCov.start 'rails'

require 'cucumber/rails'
require "rack_session_access/capybara"

require 'cucumber/rspec/doubles'

#specified require this file, because there's a same name class in app/controllers/oauth_controller.rb
Dir[File.expand_path("app/controllers/api/user/oauth_controller.rb")].each do |file|
  require file
end

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath
Capybara.javascript_driver = :webkit
Capybara.server_port = 3000
Capybara.always_include_port = true
Capybara.default_host = Settings.environments.portal_domain
Capybara.app_host = 'http://' + Settings.environments.portal_domain
# Capybara.ignore_hidden_elements = false

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end
# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner[:active_record,{:model => XmppUser}].strategy = :transaction

  Before do
    DatabaseCleaner.start
    DatabaseCleaner[:active_record,{:model => XmppUser}].start
    @redis = Redis.new(:host => Settings.redis.web_host, :port => Settings.redis.port)
  end

  After do
    DatabaseCleaner.clean
    DatabaseCleaner[:active_record,{:model => XmppUser}].clean
  end

rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# begin
#   DatabaseCleaner.strategy = :transaction
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :transaction

if Bullet.enable?
  Before do
    Bullet.start_request
  end

  After do
    Bullet.perform_out_of_channel_notification if Bullet.notification?
    Bullet.end_request
  end
end

