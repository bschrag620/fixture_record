require "test_helper"

class FixtureRecordTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert FixtureRecord::VERSION
  end

  test "it will write a record to the test fixture file" do
    user = users(:user_one)
    with_fixture_file_reset(User) do
      refute yml_contents_for(User).key? user.test_fixture_name
      user.to_fixture_record
      assert yml_contents_for(User).key? user.test_fixture_name
    end
  end

  test 'it will user the prefix and suffix values when supplied' do
    user = users(:user_one)
    user.fixture_record_prefix = :foo
    user.fixture_record_suffix = :bar
    assert user.test_fixture_name.start_with?('foo')
    assert user.test_fixture_name.end_with?('bar')
    with_fixture_file_reset(User) do
      refute yml_contents_for(User).key? user.test_fixture_name
      user.to_fixture_record
      assert yml_contents_for(User).key? user.test_fixture_name
    end
  end
end
