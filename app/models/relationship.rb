class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", required: true
  belongs_to :followed, class_name: "User", required: true
  validates :follower, presence: true
  validates :followed, presence: true
end
