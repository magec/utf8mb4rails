module Utf8mb4rails
  module Migrator

    # Abstraction for dealing with column information
    # received from the database
    class ColumnInfo
      TEXT_TYPES = %w(CHAR VARCHAR TINYTEXT TEXT MEDIUMTEXT LONGTEXT).freeze
      attr_reader :info

      # Receives a hash with (:type, :default, :max_length, :charset)
      def initialize(info)
        @info = info
      end

      # @return Bool : True if the column is in utf8mb4
      def utf8mb4?
        info[:charset] =~ /utf8mb4/
      end

      # @return String : the sql part of the new type of the column definition
      def new_type_for_sql
        info_type = info[:type]
        return "#{info_type}(#{info[:max_length]})" if info_type =~ /CHAR/

        info_type
      end

      # @return String : the sql part of the default value of the column definition
      def default_value_for_sql
        info_default = info[:default]
        return nil unless info_default

        "default '#{info_default}'"
      end

      # @return Bool : True if the column is of a text type
      def text_column?
        TEXT_TYPES.include?(info[:type])
      end
    end
  end
end
