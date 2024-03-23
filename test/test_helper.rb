# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end


def with_fixture_file_reset(*klasses)
  original_data = klasses.to_h do |klass|
    data = YAML.load_file(fixture_path_for(klass)) if File.exist?(fixture_path_for(klass))
    [klass, data]
  end

  yield

  original_data.each do |klass, data|
    if data.nil?
      File.delete(fixture_path_for_klass)
    else
      File.open(fixture_path_for(klass), 'w') { |f| f.write data.to_yaml }
    end
  end
end

def fixture_path_for(klass)
  Rails.root.join('test/fixtures', klass.table_name + '.yml')
end
