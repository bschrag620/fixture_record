module FixtureRecord
  class Loader
    class << self
      def load!(...)
        new(...).load!
      end
    end

    def initialize(*files, **opts)
      sym_opts = opts.deep_symbolize_keys
      @base_path = sym_opts[:base_path] || FixtureRecord.base_path
      @files = files.presence || Dir.entries(@base_path)
    end

    def load!
      with_modified_ar_connector do
        ActiveRecord::FixtureSet.create_fixtures(@base_path.to_s, @files)
      end
    end

    private

    # Rails already offers a way to load fixtures into the database using #insert_fixtures_set.
    # https://github.com/rails/rails/blob/main/activerecord/lib/active_record/connection_adapters/abstract/database_statements.rb#L471
    # However, because it is intended for loading test fixtures, resets the database before inserting
    # and that isn't what we want to happen. #with_modified_ar_connector will override the behavior in the
    # original method to not delete any records.
    def with_modified_ar_connector
      # first - alias the original method so we can set it back when complete
      ActiveRecord::ConnectionAdapters::DatabaseStatements.alias_method :_orig_insert_fixtures_set, :insert_fixtures_set

      # second - define a new method with the same name that will have the new behavior
      ActiveRecord::ConnectionAdapters::DatabaseStatements.define_method :insert_fixtures_set do |fixture_set, _tables_to_delete|
        fixture_inserts = build_fixture_statements(fixture_set)

        # this is the part we want to avoid when loading fixtures - we want fixture record to be able to add fixtures
        # without clearing the tables. However, there could be a future scenario where this is useful as well.
        table_deletes = [].map { |table| "DELETE FROM #{quote_table_name(table)}" }

        statements = table_deletes + fixture_inserts

        with_multi_statements do
          transaction(requires_new: true) do
            disable_referential_integrity do
              execute_batch(statements, "Fixtures Load")
            end
          end
        end
      end

      # with the new logic in place, yield so that fixturerecord can insert
      yield

    ensure
      # remove the custom method created earlier
      ActiveRecord::ConnectionAdapters::DatabaseStatements.remove_method :insert_fixtures_set

      # reverse the aliasing
      ActiveRecord::ConnectionAdapters::DatabaseStatements.alias_method :insert_fixtures_set, :_orig_insert_fixtures_set
    end
  end
end
