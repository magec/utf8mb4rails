$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rake'
Bundler.require(:default, :development)

require 'utf8mb4rails'
require 'test_database'
require 'departure'
require 'mysql2'

MIGRATION_FIXTURES = File.expand_path('../fixtures/migrate/', __FILE__)
db_config = {
  adapter: 'percona',
  host: 'localhost',
  username: 'root',
  encoding: 'utf8',
  database: 'utf8mb4rails_test'
}

ActiveRecord::Base.establish_connection(db_config)
test_database = TestDatabase.new(db_config)

RSpec.configure do |config|
  # Needs an empty block to initialize the config with the default values
  Departure.configure do |_config|
  end

  ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base) && ENV['VERBOSE']
  ActiveRecord::Migration.verbose = false

  config.before(:each) do |example|
    test_database.setup if example.metadata[:integration]
  end
end



