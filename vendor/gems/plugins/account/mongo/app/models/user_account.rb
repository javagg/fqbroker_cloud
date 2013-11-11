require "#{OpenShift::MongoAuthServiceEngine.root}/app/models/user_account"

class UserAccount
  has_many :authentications, dependent: :delete

  def self.authenticate?(user, password)
    account = self.new(user:user) do |account|
      account.password = password
    end
    return self.where(user: account.user, password_hash: account.password_hash).exists?
  end

  def authenticate?(password)
    self.class.authenticate?(self.user, password)
  end
end
