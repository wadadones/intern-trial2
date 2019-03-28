class User < ApplicationRecord
  has_many :microposts, class_name: "Micropost", dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, class_name: "User", through: :active_relationships, source: :followed
  has_many :followers, class_name: "User", through: :passive_relationships, source: :follower

  attr_accessor :remember_token
  before_save :downcase_unique_name, :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  VALID_UNIQUE_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :unique_name, presence: true, length: { in: 5..15 }, format: { with: VALID_UNIQUE_NAME_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #永続セッションのためにユーザーをDBに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false unless remember_digest.present?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  #ログイン情報破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    Micropost.including_replies(self)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private
    def downcase_unique_name
      self.unique_name.downcase!
    end

    def downcase_email
      self.email.downcase!
    end
end
