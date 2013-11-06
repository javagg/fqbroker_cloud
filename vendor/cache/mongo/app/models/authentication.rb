class Authentication
  include Mongoid::Document
  
  field :account_id, type: Integer
  field :provider, type: String
  field :uid, type: String
  
  belongs_to :account
end
