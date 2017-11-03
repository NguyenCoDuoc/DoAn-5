class User < ApplicationRecord
  
  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :conversations, :foreign_key => :sender_id
  
  attr_accessor :remember_token, :remember_digestoken, :activation_token, :reset_token

  before_save :email_downcase
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.username.maximum}
  validates :password, presence: true, length: {minimum: Settings.password.minimum},
    allow_nil: true
    

  has_secure_password

  include PgSearch #tim kiem
  pg_search_scope :search_by_full_name, against: [:name]

  #  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/fb_profile_cover_13173327520f7.png"
  # # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # do_not_validate_attachment_file_type :image

  def is_user? user
    self == user
  end

 class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.user.reset_expired_time.hours.ago
  end

  def feed
    Micropost.feed_by_user(following_ids, id).order_by
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    if search
      where('name LIKE ? OR email LIKE ?', "%#{search}%","%#{search}%")
    else
      all
    end
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def self.from_omniauth(auth_hash)
    user = find_or_create_by(uid: auth_hash['uid'], prodiver: auth_hash['provider'])
    user.name = auth_hash['info']['first_name']
    user.email = auth_hash['info']['email']
    user.password = '123456'

    user.save!
    user
  end
  private

  def email_downcase
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
 
end

