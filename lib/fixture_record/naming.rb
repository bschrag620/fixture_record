module FixtureRecord
  module Naming
    attr_accessor :fixture_record_prefix
    attr_accessor :fixture_record_suffix

    class Base
      def call(record)

        [record.fixture_record_prefix, record.class.model_name.param_key, record.id || 'new', record.fixture_record_suffix].compact_blank.join
      end
    end

    def test_fixture_name
      FixtureRecord.naming.call(self)
    end
  end
end
