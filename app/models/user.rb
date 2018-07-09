class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :downcase_email

  validates :name, presence: Settings.user.name.presence,
            length: {maximum: Settings.user.name.max_length}
  validates :email, presence: Settings.user.email.presence,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: Settings.user.email.uniqueness
  validates :password, presence: Settings.user.password.presence,
            length: {minimum: Settings.user.password.min_length}
  has_secure_password

  private
  def downcase_email
    self.email = email.downcase
  end
end
