Rails.application.routes.draw do
  scope "broker/rest" do
    # NOTE: make sure that account::create is overrided by this
    resources :accounts, :only => :index
    # NOTE: This remove the 'constraints(:ip => %r(127.0.\d+.\d+))'
    # and can be a security problem
    resources :accounts, :only => :create, :controller => :account
    resources :authentications
  end
end

