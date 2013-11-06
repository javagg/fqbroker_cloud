class AccountsController < BaseController
  skip_before_filter :authenticate_user!

  def index
    [:controller, :action, :format].each { |key| params.delete(key) }
    user = params[:username].presence
    password = params.delete(:password)

    rest_accounts = []
    UserAccount.where(user: user).each do |account|
      next if password.present? && !UserAccount.authenticate?(account.user, password)
      rest_account = RestAccount.new(account.user, account.created_at)
      rest_account.password = password if password.present?
      rest_accounts.push rest_account
    end

    render_success(:ok, "accounts", rest_accounts, "Showing #{rest_accounts.size} accounts")
  end

  def set_log_tag
    @log_tag = get_log_tag_prepend + "ACCOUNT"
  end
end

