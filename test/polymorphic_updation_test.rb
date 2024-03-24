require 'test_helper'

class PolymorphicUpdationTest < ActiveSupport::TestCase
  test 'it should update polymorphic relationship values properly' do
    post = posts(:post_1)

    with_fixture_file_reset(Post, Comment) do
      post.to_test_fixture(:comments)
      comment = post.comments.first

      comment_fixture = yml_contents_for(Comment)[comment.test_fixture_name]

      refute comment_fixture.key?('commentable_type')
      assert_equal "#{post.test_fixture_name} (Post)", comment_fixture['commentable']
    end
  end
end
