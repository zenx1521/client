class UserAuthenticator 
  require 'net/http'
  require 'json'

  ERRORS = {
    "USER_NOT_FOUND" => "User with this token doesn't exist"
  }

  def authenticate(token)
    uri = URI('http://localhost:3000/api/v1/users/authenticate')
    params = {:token => token}
    response =  Net::HTTP.post_form(uri,params)
    response_body = JSON.parse(response.body,object_class: OpenStruct)
    puts ERRORS[response_body.error] if response_body.error
    if response_body.status == "SUCCESS"
        puts "Logged in successfully"
        return true
    end
    false
  end
end