module FixtureRecord
  module Sanitizers
    class SimpleTimestamp < FixtureRecord::Sanitizer
      def cast(value)
        value.to_s
      end
    end
    FixtureRecord.registry.register_sanitizer(FixtureRecord::Sanitizers::SimpleTimestamp, as: :simple_timestamp)
  end
end

