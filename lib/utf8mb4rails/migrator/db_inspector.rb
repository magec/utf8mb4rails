module Utf8mb4rails
  module Migrator
    class DBInspector
      # Initializes AR
      def initialize
        ActiveRecord::Base.establish_connection(
          ActiveRecord::Base.connection_config.merge(adapter: 'percona')
        )
      end

      ##
      # @returns [Array<String>] An array with column names
      def columns(table)
        ActiveRecord::Base.connection.columns(table).map(&:name)
      end

      # Returns a hash with information about the column
      #
      # @param [String] table
      # @param [String] column
      #
      # @returns [Hash] { type: String, default: String or nil, charset: String or nil }
      def column_info(table, column)
        sql = "SELECT DATA_TYPE, COLUMN_DEFAULT, CHARACTER_SET_NAME, CHARACTER_MAXIMUM_LENGTH
        FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '#{table}'
        AND COLUMN_NAME = '#{column}'
        AND TABLE_SCHEMA='#{database_name}'"
        result = ActiveRecord::Base.connection.execute(sql).first
        ColumnInfo.new(
          type: result[0].upcase,
          default: result[1],
          charset: result[2],
          max_length: result[3]
        )
      end

      private

      def database_name
        ActiveRecord::Base.connection.current_database
      end
    end
  end
end
