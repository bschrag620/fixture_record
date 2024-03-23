module FixtureRecord
  class Cache < Hash

    def dump!
      prepare!
      merge_data!
      FixtureRecord.data.write!
    end

    def merge_data!
      self.each do |fixture_id, record|
        FixtureRecord.data.merge_record(record)
      end
    end

    def prepare!
      self.values
        .each(&:filter_attributes_for_test_fixture)
        .each(&:sanitize_attributes_for_test_fixture)
    end
  end
end
