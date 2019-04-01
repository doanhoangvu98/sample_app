class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.pwd.minimum},
    allow_nil: true

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create(string, cost: cost)
  end

  # returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # returns true if the given token matches the digest
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at:
      Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < Settings.expired.time.hours.ago
  end

  # See "Following users" for the full implementation.
  def feed
    Micropost.load_user_id id
  end

  private

  # converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
