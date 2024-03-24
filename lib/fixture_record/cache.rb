module FixtureRecord
  class Cache < Hash

    def dump!
      prepare!
      merge_data!
      handle_belongs_to!
      FixtureRecord.data.write!
    end

    def handle_belongs_to!
      self.each do |_, record|
        record.class.reflect_on_all_associations(:belongs_to).each do |assoc|
          belongs_to = record.send(assoc.name)
          if invert.key? belongs_to
            record._fixture_record_attributes.delete assoc.foreign_key
            record._fixture_record_attributes[assoc.name.to_s] = belongs_to.test_fixture_name
          end
        end
      end
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
