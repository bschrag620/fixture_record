require 'test_helper'

class TraversalTest < ActiveSupport::TestCase
  test 'simple traversal' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post) do
      refute File.exist? fixture_path_for(Post)
      user.to_test_fixture(:posts)
      assert File.exist? fixture_path_for(Post)
      assert_equal 2, yml_contents_for(Post).length
    end
  end
end
