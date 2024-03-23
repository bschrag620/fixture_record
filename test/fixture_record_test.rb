require "test_helper"

class FixtureRecordTest < ActiveSupport::TestCase
  def yml_contents(klass)
    YAML.load_file(Rails.root.join('test/fixtures', klass.table_name + '.yml'))
  end

  test "it has a version number" do
    assert FixtureRecord::VERSION
  end

  test "it will write a record to the test fixture file" do
    user = User.first
    with_fixture_file_reset(User) do
      refute yml_contents(User).key? user.test_fixture_name
      user.to_test_fixture
      assert yml_contents(User).key? user.test_fixture_name
    end
  end

  test 'it will user the prefix and suffix values when supplied' do
    user = User.first
    user.fixture_record_prefix = :foo
    user.fixture_record_suffix = :bar
    assert user.test_fixture_name.start_with?('foo')
    assert user.test_fixture_name.end_with?('bar')
    with_fixture_file_reset(User) do
      refute yml_contents(User).key? user.test_fixture_name
      user.to_test_fixture
      assert yml_contents(User).key? user.test_fixture_name
    end
  end
end
