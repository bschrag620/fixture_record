module FixtureRecord::Sanitizable
  extend ActiveSupport::Concern

  def sanitize_attributes_for_test_fixture
    _fixture_record_attributes.each do |attr, value|
      registry_key = [self.class.name, attr.to_s].join('.')
      _fixture_record_attributes[attr] = sanitize_value_for_test_fixture(registry_key, value)
    end
  end

  def sanitize_value_for_test_fixture(registry_key, value)
    FixtureRecord.registry.fetch(registry_key).inject(value) do |agg, sanitizer|
      agg = sanitizer.cast(agg)
    end
  end

  class Base
    def cast(value)
      raise NotImplementedError.new "#cast must be defined in #{self.class.name} and it is not"
    end
  end

  class Registry
    @_fixture_record_sanitizer_pattern_registry = []
    @_fixture_record_sanitizer_name_registry = {}

    def self.[](...)
      @_fixture_record_sanitizer_name_registry.send(:[], ...)
    end

    def self.sanitize_pattern(pattern, with:)
       @_fixture_record_sanitizer_pattern_registry << [pattern, with]
    end

    def self.register_sanitizer(klass, as: nil)
      @_fixture_record_sanitizer_name_registry[as.to_sym] = klass.new
    end

    def self.fetch(to_be_matched)
      @_fixture_record_sanitizer_pattern_registry.select { |pattern, value| to_be_matched.match(pattern) }.map(&:last)
    end
  end
end
