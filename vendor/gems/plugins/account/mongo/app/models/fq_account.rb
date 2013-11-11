require 'digest/md5'

class FqAccount
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "auth_user"

  field :user, type: String
  field :password_hash, type: String
  attr_reader :password

  has_many :authentications, dependent: :delete

  def password=(password)
    @password = password
    salt = Rails.application.config.auth[:salt]
    self.password_hash = Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + salt)
  end

  def self.authenticate?(user, password)
    account = self.new(user: user) do |account|
      #TODO remove email?
      account.password = password
    end
    return self.where(user: account.user, password_hash: account.password_hash).exists?
  end

  def authenticate?
    self.class.authenticate?(self.user, self.password)
  end
end
