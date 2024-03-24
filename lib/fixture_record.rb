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
  mattr_accessor :_locked_by, :cache, :data

  included do
    attr_accessor :_fixture_record_attributes
  end

  include FixtureRecord::Naming
  include FixtureRecord::AssociationTraversal
  include FixtureRecord::FilterableAttributes
  include FixtureRecord::Sanitizable
  include FixtureRecord::BelongsToUpdation

  Sanitizer = FixtureRecord::Sanitizable::Base

  def to_test_fixture(*associations)
    FixtureRecord.lock!(self)
    FixtureRecord.cache[self.test_fixture_name] ||= self
    traverse_fixture_record_associations(*associations)
    FixtureRecord.cache.dump! if  FixtureRecord.locked_by?(self)
  ensure
    FixtureRecord.release!(self)
  end

  class << self
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
