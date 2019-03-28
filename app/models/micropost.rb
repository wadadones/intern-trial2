class Micropost < ApplicationRecord
  belongs_to :user, class_name: "User", required: true
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size #バリデーション独自定義はvalidatesではなくvalidate
  scope :including_replies, -> (user) { where(user_id: user.following_ids).or(where(user_id: user.id)).or(where(in_reply_to: user.id)) }

  private
    #画像サイズバリデーション
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
