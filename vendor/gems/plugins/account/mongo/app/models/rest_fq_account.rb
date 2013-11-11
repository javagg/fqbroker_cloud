class RestFqAccount < OpenShift::Model
  attr_accessor :email
  #attr_accessor :username
  attr_accessor :password
  attr_accessor :created_on

  def initialize(account)
    #self.email = account.email
    self.email = account.user
    self.password = account.password
    self.created_on = account.created_at
  end
  
  def to_xml(options = {})
    options[:tag_name] = "account"
    super(options)
  end
end
