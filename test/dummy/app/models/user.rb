class User < ApplicationRecord
  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :post_comments, through: :posts, source: :comments, dependent: :destroy
  has_many :commenting_users, through: :post_comments, source: :user
end
