module FixtureRecord
  class Cache < Hash

    def dump!
      prepare!
      merge_data!
      FixtureRecord.data.write!
    end

    def contains_class?(klass_or_string)
      klass = klass_or_string.is_a?(String) ? klass_or_string.constantize : klass_or_string
      values.map(&:class).include?(klass)
    end

    def contains_record?(record)
      invert.key? record
    end

    def merge_data!
      self.each do |fixture_id, record|
        FixtureRecord.data.merge_record(record)
      end
    end

    def prepare!
      self.values
        .each(&:filter_attributes_for_fxiture_record)
        .each(&:sanitize_attributes_for_fxiture_record)
        .each(&:update_belongs_to_fixture_record_associations)
    end
  end
end
