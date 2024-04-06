require "fixture_record/version"
require "fixture_record/railtie"
require "fixture_record/cache"
require "fixture_record/data"
require "fixture_record/naming"
require "fixture_record/association_traversal"
require "fixture_record/filterable_attributes"
require "fixture_record/belongs_to_updation"
require "fixture_record/sanitizable"

module FixtureRecord
  extend ActiveSupport::Concern
  mattr_accessor :_locked_by,
    :cache,
    :data

  mattr_accessor :name_handler, default: FixtureRecord::Naming::Base.new
  mattr_accessor :sanitizers, default: []
  mattr_accessor :base_path, default: -> { Rails.root.join('test/fixtures') }

  included do
    attr_accessor :_fixture_record_attributes
  end

  include FixtureRecord::Naming
  include FixtureRecord::AssociationTraversal
  include FixtureRecord::FilterableAttributes
  include FixtureRecord::Sanitizable
  include FixtureRecord::BelongsToUpdation

  Sanitizer = FixtureRecord::Sanitizable::Base

  def to_fixture_record(*associations)
    FixtureRecord.lock!(self)
    FixtureRecord.cache[self.test_fixture_name] ||= self
    traverse_fixture_record_associations(*associations)
    FixtureRecord.cache.dump! if  FixtureRecord.locked_by?(self)
  ensure
    FixtureRecord.release!(self)
  end


  class << self
    def configure
      yield self
    end

    def base_path
      @@base_path.is_a?(String) ? @@base_path : @@base_path.call
    end

    def name_handler=(proc_or_klass)
      @@name_handler = proc_or_klass.is_a?(Class) ? proc_or_klass.new : proc_or_klass
    end

    def sanitize_column_regex(col_regex, with:)
      registry_name_or_klass = with
      klass = registry_name_or_klass.is_a?(Symbol) ? FixtureRecord.registry[registry_name_or_klass] : registry_name_or_klass
      klass_instance = klass.is_a?(Class) ? klass.new : klass
      FixtureRecord.registry.sanitize_pattern col_regex, with: klass_instance
    end

    def lock!(owner)
      return if locked?

      @@_locked_by = owner
      @@cache = FixtureRecord::Cache.new
      @@data = FixtureRecord::Data.new
    end

    def locked?
      @@_locked_by.present?
    end

    def release!(owner)
      if locked_by?(owner)
        @@_locked_by = nil
        @@_cache = nil
        true
      else
        false
      end
    end

    def locked_by?(owner)
      @@_locked_by == owner
    end

    def registry
      FixtureRecord::Sanitizable::Registry
    end
  end
end

require "fixture_record/sanitizers/simple_timestamp"
