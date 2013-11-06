class RestAuthentication < OpenShift::Model
  attr_accessor :provider, :uid
  attr_accessor :user_id

  def initialize(authentication)
    self.provider = authentication.provider
    self.uid = authentication.uid
    self.user_id = authentication.user_id
  end
  
  def to_xml(options = {})
    options[:tag_name] = "authentication"
    super(options)
  end
end
