require 'test_helper'

class BelongsToUpdation < ActiveSupport::TestCase
  test 'it should update belongs to records to reflect newly created associations' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post) do
      user.to_fixture_record(:posts)
      post_fixtures = yml_contents_for(Post)
      assert_includes post_fixtures.values.second.keys, 'author'
    end
  end
end
