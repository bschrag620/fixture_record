class User < ApplicationRecord
  has_many :posts, foreign_key: :author_id
  has_many :post_comments, through: :posts, source: :comments
  has_many :commenting_users, through: :post_comments, source: :user
end
