class User < ApplicationRecord
  has_many :microposts
  attr_reader :remember_token, :activation_token, :reset_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  scope :select_user_activated, (lambda do
                                   select(:name, :email, :id, :admin)
                                   .where(activated: true).order(:name)
                                 end)

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: Settings.user.name.presence,
            length: {maximum: Settings.user.name.max_length}
  validates :email, presence: Settings.user.email.presence,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: Settings.user.email.uniqueness
  validates :password, presence: Settings.user.password.presence,
            length: {minimum: Settings.user.password.min_length},
            allow_nil: true
  has_secure_password

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
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(@remember_token)
  end

  def authenticated? attribute, remember_token
    digest = send "#{attribute}_digest"

    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? current_user
    self == current_user
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    @reset_token = User.new_token
    update_columns reset_digest: User.digest(@reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.user.reset_password.expire_time_days.hours.ago
  end

  def feed
    Micropost.where "user_id = ?", id
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
