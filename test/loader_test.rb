require 'test_helper'

class LoaderTest < ActiveSupport::TestCase
  test 'it should add the records to the database' do
    Comment.destroy_all
    User.destroy_all

    ActiveRecord::FixtureSet.reset_cache
    assert_equal 0, User.count

    FixtureRecord.load!(:users, base_path: Rails.root.join('..', 'fixtures'))
    assert_equal 2, User.count
  end
end
