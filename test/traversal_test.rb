require 'test_helper'

class TraversalTest < ActiveSupport::TestCase
  test 'simple traversal' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post) do
      refute File.exist? fixture_path_for(Post)
      user.to_fixture_record(:posts)
      assert File.exist? fixture_path_for(Post)
      assert_equal 2, yml_contents_for(Post).length
    end
  end

  test 'complex traversal' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post, Comment) do
      user.to_fixture_record(posts: [comments: :user])
      assert_equal 2, yml_contents_for(User).length
      assert_equal 2, yml_contents_for(Post).length
      assert_equal 1, yml_contents_for(Comment).length
    end
  end

  test 'starting in the middle' do
    post = posts(:post_1)
    with_fixture_file_reset(User, Post, Comment) do
      post.to_fixture_record(:author, comments: :user)
      assert_equal 2, yml_contents_for(User).length
      assert_equal 1, yml_contents_for(Post).length
      assert_equal 1, yml_contents_for(Comment).length
    end
  end
end
