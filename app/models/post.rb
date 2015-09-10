class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :categories
  has_many :comments
  validates :title, presence: true
  validates :body, presence: true
end
