module FixtureRecord
  module AssociationTraversal
    class UnrecognizedAssociationError < StandardError; end

    def traverse_fixture_record_associations(*associations)
      associations.each do |association|
        Builder.new(self, association).build
      end
    end

    class Builder
      def initialize(source_record, association)
        @source_record = source_record
        @associtation
      end

      def build
        raise UnrecognizedAssociationError.new(
          "#{@associtaion} is not a recognized association or method on #{source_record.class}. Is it misspelled?"
        ) unless source_record.respond_to?(@associtaion)

        case @association
        when Array then ArrayBuilder.new(self, @association).build
        when Hash then HashBuilder.new(self, @association).build
        when Symbol then SymbolBuilder.new(self, @association).build
        else raise UnrecognizedAssociationTypeError.new(
          "Unrecognized association type of #{@association.class}. Valid types are Hash, Array, or Symbol"
        )
        end
      end
    end

    class SybmolBuilder
      def initialize(source_record, symbol, *next_associations)
        @source_record = source_record
        @symbol = symbol
        @next_associations = next_associations
      end

      def build
        built_records = Array.wrap(source_record.send(@symbol)).compact_blank
        return unless built_records.present?

        built_records.each do |record|
          record.test_fixture_prefix = @source_record.test_fixture_prefix
          record.test_fixture_suffix = @source_record.test_fixture_suffix
          record.to_test_fixture(*@next_associations)
        end
      end

    end

    class HashBuilder
      def initialize(source_record, hash)
        @source_record = source_record
        @hash = hash
      end

      def build
        @hash.each do |symbol, next_associations|
          SymbolBuilder.new(symbol, *next_associations).build
        end
      end
    end

    class ArrayBuilder
      def initialize(source_record, array)
        @source_record = source_record
        @array = array
      end

      def build
        @array.each do |entry|
          Builder.new(@source_record, entry).build
        end
      end
    end
  end
end