require 'English'

module Utf8mb4rails
  module Migrator
    # This class will perform the actual migration, will run sql queries that
    # alters tables
    class Runner
      NEW_COLLATION = ENV.fetch('COLLATION', 'utf8mb4_unicode_520_ci').freeze

      attr_reader :inspector

      def initialize
        @inspector = DBInspector.new
      end

      # :reek:FeatureEnvy
      def migrate_column!(table, column)
        column_info = inspector.column_info(table, column)
        if column_info.utf8mb4?
          puts "          Skipping column #{column} (already in utf8mb4)'"
          return
        end
        return unless column_info.text_column?
        sql = "ALTER TABLE `#{table}` DROP COLUMN \`#{column}`\ ,
       ADD COLUMN \`#{column}`\ #{column_info.new_type_for_sql} CHARACTER SET utf8mb4
       COLLATE #{NEW_COLLATION} #{column_info.default_value_for_sql}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def migrate_table!(table)
        sql = []
        inspector.columns(table).each do |column|
          column_info = inspector.column_info(table, column)
          next if column_info.utf8mb4? || !column_info.text_column? || skipped_column?(column)
          sql << "DROP COLUMN \`#{column}`"
          sql << "ADD COLUMN \`#{column}`\ #{column_info.new_type_for_sql} \
CHARACTER SET utf8mb4 COLLATE #{NEW_COLLATION} #{column_info.default_value_for_sql}"
        end
        sql << "CONVERT TO CHARACTER SET utf8mb4 COLLATE #{NEW_COLLATION}"
        ActiveRecord::Base.connection.execute("ALTER TABLE `#{table}` #{sql.join(' , ')};")
      rescue
        puts "Problems accesing the table #{table}"
        puts $ERROR_INFO
        exit 1
      end

      private

      # :reek:UtilityFunction
      def skipped_column?(column_name)
        return false unless ENV.key? 'SKIP_COLUMNS'
        skipped_columns = ENV['SKIP_COLUMNS'].join(',')
        skipped_columns.include(column_name)
      end
    end
  end
end
