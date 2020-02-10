
class PokerSessionCreator
  require 'net/http'
  require 'json'

  def create(number_of_voting,token) 
    uri = URI('http://localhost:3000/api/v1/poker_sessions')
    params = {:number_of_voting => number_of_voting,:token => token}
    response = Net::HTTP.post_form(uri,params)
    body_json = JSON.parse(response.body, object_class: OpenStruct)
    puts body_json.message
    puts "Poker session id : " + body_json.data.id.to_s
    [body_json.data.id, body_json.status]
  end
end