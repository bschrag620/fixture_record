module FixtureRecord
  module FilterableAttributes
    def filter_attributes_for_fxiture_record
      self._fixture_record_attributes = FilteredAttributes.new(self).cast
    end

    class FilteredAttributes
      attr_reader :record
      def initialize(record)
        @record = record
      end

      def db_columns
        record.class.columns.map(&:name)
      end

      def excluded_columns
        %w( id )
      end

      def applicable_columns
        db_columns - excluded_columns
      end

      def cast
        record.attributes.slice(*applicable_columns)
      end
    end
  end
end
