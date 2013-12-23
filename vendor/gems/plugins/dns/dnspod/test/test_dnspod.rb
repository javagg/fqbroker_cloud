require 'httpclient'
require 'json'
require 'securerandom'


h = HTTPClient.new


url = "https://dnsapi.cn/Domain.Info"
default_params = {
  :login_email => 'lu.lee05@gmail.com',
  :login_password => "hello!2345",
  :format => 'json'
}
params = default_params.merge({ :domain => 'freequant.org'})
res = h.post(url, params)
domain_id = JSON.parse(res.content)['domain']['id']

url = "https://dnsapi.cn/Record.List"
params = default_params.merge({ :domain_id => domain_id })
res = h.post(url, params)
puts res.content
res = JSON.parse(res.content)
puts res['records'][0]

url = "https://dnsapi.cn/Record.Create"
hostname = SecureRandom.hex[0..5]

params = default_params.merge({
  :domain_id => domain_id,
  :sub_domain => hostname,
  :record_type => 'A',
  :record_line => '默认',
  :value => '129.22.22.1'
})

res = h.post(url, params)
res = JSON.parse(res.content)
puts res


