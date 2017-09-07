module Utf8mb4rails
  module Migrator
    class Runner
      NEW_COLLATION = ENV.fetch('COLLATION', 'utf8mb4_unicode_520_ci').freeze

      attr_accessor :inspector

      def initialize
        @inspector = DBInspector.new
      end

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

      def migrate_table_schema!(table)
        sql = "ALTER TABLE `#{table}` CONVERT TO CHARACTER SET utf8mb4 COLLATE #{NEW_COLLATION}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def migrate_table!(table)
        inspector.columns(table).each do |column|
          puts "      migrating #{table}:#{column}"
          migrate_column!(table, column)
        end
        migrate_table_schema!(table)
      rescue
        puts "Problems accesing the table #{table}"
        puts $!
        exit 1
      end
    end
  end
end
