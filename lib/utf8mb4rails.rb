require 'utf8mb4rails/version'
require 'utf8mb4rails/migrator'

def usage
  puts
  puts 'Usage: '
  puts
  puts 'For migrating an entire table use:'
  puts '$ TABLE=table_name rake db:utf8mb4'
  puts
  puts 'For migrating an specified column table:'
  puts '$ TABLE=table_name COLUMN=column_name rake db:utf8mb4'
  puts
  puts 'You can also specify the COLLATION (utf8mb4_unicode_520_ci)'
end

module Utf8mb4rails
  extend Rake::DSL

  namespace :db do
    desc 'migrates a table[/column] (TABLE, COLUMN env vars) to utf8mb encoding'
    task utf8mb4: :environment do
      require 'departure'
      Departure.configure do |_config|; end

      table = ENV['TABLE']
      unless table
        puts 'Please specify a table with TABLE='
        usage
        exit 1
      end

      column = ENV['COLUMN']
      runner = Migrator::Runner.new
      if column
        puts "Migrating #{table}.#{column}"
        runner.migrate_column!(table, column)
      else
        puts 'No column specified, will migrate the entire table'
        runner.migrate_table!(table)
      end
    end
  end
end
