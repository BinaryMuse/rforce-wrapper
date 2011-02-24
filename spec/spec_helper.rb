RSpec.configure do |config|
  config.mock_with :mocha
end

TEST_USER       = 'test@user.com'
TEST_PASS       = 'abcdefg'
TEST_TOKEN      = '1234567890'
TEST_PASS_TOKEN = TEST_PASS + TEST_TOKEN
API_METHOD      = :remoteCall

def api_response_fault
  { :Fault => {
      :faultcode   => 'FAULT_101',
      :faultstring => 'This is a faulty fault!'
    }
  }
end

def api_response_for(method)
  response_key = "#{method.to_s}Response"
  { response_key.to_sym => {
      :result => {
        'key' => 'value'
      }
    }
  }
end

def api_results_for(method)
  response_key = "#{method.to_s}Response"
  response = api_response_for(method)
  [response[response_key.to_sym][:result]]
end
