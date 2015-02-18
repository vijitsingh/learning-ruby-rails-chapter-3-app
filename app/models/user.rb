class User < ActiveRecord::Base 
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save {self.email = self.email.downcase}
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
 
  def authenticated?(attribute, token)
    attribute_digest = self.send("#{attribute}_digest")
    return false if token.nil?
    BCrypt::Password.new(attribute_digest).is_password?(token)
  end 

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Remembers a user in the database for use in persistent sessions.
  def User.new_token 
    SecureRandom.urlsafe_base64
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(self.reset_token)) # NOTE here that we have to call update_attributes so that the value gets saved in db as well. 
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_mail
    UserMailer.password_reset(self).deliver_now
  end
 
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private 

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token) 
  end
end
