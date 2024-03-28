# FixtureRecord
When it comes to testing, ActiveRecrod::Fixtures provide a huge performance benefit over FactoryBot but at the expense of setting up the necessary test data. For complex associations and relationships, a large amount of time might be spent simply trying to setup the data. FixtureRecord provides a `to_test_fixture` method that accepts a chain of associations as an argument that allows you to quickly turn a large collection of existing records into test fixtures.

## Usage
`to_test_fixture` is a method that will turn the record into a test fixture. By default, the name of the fixture record will be `param_key` of the record's class and the record's id joined with `_`.

```ruby
user = User.find(1)
user.to_test_fixture

# creates test/fixtures/users.yml if it does not exists
```
```yaml
# users.yml

user_1:
  email: the-user-email@domain.com
  first_name: Foo
  last_name: Bar
```

### Associations
Let's take a basic Blog app with the classes User, Post, and Comment:
```ruby
class User
  has_many :posts, foreign_key: :author_id
  has_many :comments
end

class Post
  has_many :comments
  belongs_to :author, class_name: 'User'
end

class Comment
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
```
Let's say an edge case bug has been found with a particular post and it's related comments. To write the test, you need the post record, its authors, the comments, and the user for each of the comments to properly replicate the edge case.

```ruby
edge_case_post = Post.find ...
edge_case_post.to_test_fixture(:author, comments: :user)
```
This would create a test fixture for the post, its author, all the comments on the post and their respective users. This will also change the `belongs_to` relationships in the yaml files to reflect their respective fixture counterparts. For example, if `Post#12` author is `User#49`,
and the post has `Comment#27` the fixture records might look like:
```yaml
# users.yml

user_49:
  email: user-49@tester.com
  ...

# posts.yml
post_12:
  author: user_49
  ...

# comments.yml
comment_27:
  user: user_1
  commentable: post_12 (Post)
```

Note that these changes to the `belongs_to` associations is only applicable to records that are part of the associations that are being passed into `to_test_fixture`. So taking the same example as above, `edge_case_post.to_test_fixture` would yield the following:
```yaml
post_12:
  author_id: 49
```

Currently, `FixtureRecord` will also not attempt to already existing fixtures to newly created data.
```ruby
User.find(49).to_test_fixture
Post.find(12).to_test_fixture
```
The above would yield fixtures that are not associated to one another.
```yaml
# users.yml
user_49:
  ...


# posts.yml
post_12:
  author_id: 49
```

### Through Associations
`FixtureRecord` will automatically attempt to infill any missing associations when an association utilizes a `through` option. Taking the blog example, consider a `User` class:
```ruby
class User
  has_many :posts
  has_many :post_comments, through: :posts, source: :comments
  has_many :commenting_users, through: :post_comments, source: :user
end
```
Because of through association infilling the following 3 lines will produce identical results:
```ruby
user.to_test_fixture(posts: [comments: :users])

user.to_test_fixture(:posts, :post_comments, :commenting_users)

user.to_test_fixutre(:commenting_users)
```
The reason the third example will infill the other associations is because those associations are required to create a clear path between the originating record and the final records. Without those intermediary associations, the `:commenting_users` would be orphaned from the `user` record.

### FixtureRecord::Naming
There might be instances where a record was used for a particular test fixture and you want to use this same record again for a different test case but want to keep the data isolated. `FixtureRecord::Naming` (automatically included with FixtureRecord) provides`fixture_record_prefix` and `fixture_record_suffix`. These values are propagated to the associated records when calling `to_test_fixture`.
```ruby
user.test_fixture_prefix = :foo
user.to_test_fixture(:posts)

# users.yml

foo_user_12:
  ...


# posts.yml

foo_post_49:
  author: foo_user_12
  ...
```

## Installation
`FixtureRecord` is only needed as a development dependency.
```ruby
bundle add fixture_record --group development
```

Or add directly to your Gemfile:
```ruby
# Gemfile

group :development do
  ...
  gem 'fixture_record'
end
```

And then execute:
```bash
$ bundle install
```

Finally, run the installer:
```bash
$ rails g fixture_record:install
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
