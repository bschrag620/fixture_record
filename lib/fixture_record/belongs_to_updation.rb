module FixtureRecord
  module BelongsToUpdation
    extend ActiveSupport::Concern

    def update_belongs_to_fixture_record_associations
      self.class.reflect_on_all_associations(:belongs_to).each do |assoc|
        klass_name = assoc.options[:polymorphic] ? send(assoc.foreign_type) : assoc.class_name
        next unless klass_name.nil? || FixtureRecord.cache.contains_class?(klass_name)

        belongs_to = send(assoc.name)
        if FixtureRecord.cache.contains_record? belongs_to
          _fixture_record_attributes.delete assoc.foreign_key
          foreign_key_value = belongs_to.test_fixture_name
          if assoc.options[:polymorphic]
            _fixture_record_attributes.delete assoc.foreign_type
            foreign_key_value = "#{foreign_key_value} (#{belongs_to.class})"
          end
          _fixture_record_attributes[assoc.name.to_s] = foreign_key_value
        end
      end
    end
  end
end
