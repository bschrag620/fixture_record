require 'test_helper'

class ThroughAssociationTest < ActiveSupport::TestCase
  test 'it should infill missing through associations' do
    user = users(:user_one)
    with_fixture_file_reset(User, Post, Comment) do
      user.to_fixture_record(:commenting_users)
      assert_equal 2, yml_contents_for(User).length
      assert_equal 2, yml_contents_for(Post).length
      assert_equal 1, yml_contents_for(Comment).length
    end
  end

   test 'it should not need to call the infill method missing through associations' do
    user = users(:user_one)
    called = false
    mocked = -> { called = true }
    with_fixture_file_reset(User, Post, Comment) do
      FixtureRecord::AssociationTraversal::SymbolBuilder.stub_any_instance(:infill_through, mocked) do
        user.to_fixture_record(:posts, :post_comments, :commenting_users)
      end
    end

    refute called
  end
end
