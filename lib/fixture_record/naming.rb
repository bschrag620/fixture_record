module FixtureRecord
  module Naming
    attr_accessor :fixture_record_prefix
    attr_accessor :fixture_record_suffix

    def test_fixture_name
      [fixture_record_prefix, self.class.model_name.param_key, (self.id || 'new'), fixture_record_suffix].compact_blank.join '_'
    end
  end
end
