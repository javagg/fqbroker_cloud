class AuthenticationsController < BaseController
  skip_before_filter :authenticate_user!

  def index
    provider = params[:provider].presence
    uid = params[:uid].presence
    authentications = Authentication.where(provider: provider, uid: uid)
    rest_authentications = []
    authentications.each do |a|
      rest_authentications << RestAuthentication.new(a)
    end
    render_success(:ok, "authentications", rest_authentications, "Showing #{rest_authentications.size} authentication")
  end

  def set_log_tag
    @log_tag = get_log_tag_prepend + "AUTHENTICATION"
  end
end
