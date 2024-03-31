module FixtureRecord
  class Configuration
    def naming=(proc_or_klass)
      FixtureRecord.naming = proc_or_klass.is_a?(Class) ? proc_or_klass.new : proc_or_klass
    end

    def sanitize_pattern(pattern, with:)
      registry_name_or_klass = with
      klass = registry_name_or_klass.is_a?(Symbol) ? FixtureRecord.registry[registry_name_or_klass] : registry_name_or_klass
      klass_instance = klass.is_a?(Class) ? klass.new : klass
      FixtureRecord.registry.sanitize_pattern pattern, with: klass_instance
    end
  end
end
