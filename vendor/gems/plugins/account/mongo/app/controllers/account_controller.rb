require "#{OpenShift::MongoAuthServiceEngine.root}/app/controllers/account_controller"
class AccountController
  skip_before_filter :authenticate_user!
end

