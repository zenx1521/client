class PokerSessionCreator
  require 'net/http'
  require 'json'

  ERRORS = {
    "SESSION_NOT_SAVED" => "Session didn't save"
  }

  def create(number_of_voting,token) 
    uri = URI('http://localhost:3000/api/v1/poker_sessions')
    params = {:number_of_voting => number_of_voting, :token => token}
    response = Net::HTTP.post_form(uri,params)
    body_json = JSON.parse(response.body, object_class: OpenStruct)
    status = body_json.error ? false : true
    puts ERRORS[body_json.error] if status
    [body_json.data.id, status]
  end
end