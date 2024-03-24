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

  test 'complex traversal' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post, Comment) do
      user.to_test_fixture(posts: [comments: :user])
      assert_equal 2, yml_contents_for(User).length
      assert_equal 1, yml_contents_for(Comment).length
    end
  end
end
