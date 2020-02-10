class UserAuthenticator 
    require 'net/http'
    require 'json'

    def authenticate(token)
        uri = URI('http://localhost:3000/api/v1/users/authenticate')

        params = {:token => token}
        response =  Net::HTTP.post_form(uri,params)
        response_body = JSON.parse(response.body,object_class: OpenStruct)
        puts response_body.message
        response_body.status
    end

end