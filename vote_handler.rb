class VoteHandler
    require 'net/http'
    require 'json'

    def create(vote_value,poker_session_id,token)
        uri = URI('http://localhost:3000/api/v1/poker_sessions/' + poker_session_id.to_s + '/votes')
        params = {:value => vote_value,:token => token}
        response = Net::HTTP.post_form(uri,params)
        response_body = JSON.parse(response.body, object_class: OpenStruct) 
        puts response_body.message
        response_body.status
    end
end