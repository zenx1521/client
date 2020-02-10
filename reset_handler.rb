class ResetHandler
    require 'net/http'
    require 'json'

    def reset(token,poker_session_id) 
        uri = URI('http://localhost:3000/api/v1/poker_sessions/' + poker_session_id.to_s + '/reset_session')
        params = {:token => token}
        response = Net::HTTP.post_form(uri,params)
        body_json = JSON.parse(response.body, object_class: OpenStruct)
        puts "Wrong session id!" if body_json.status == 404 
        puts body_json.message
        body_json.status
    end
end