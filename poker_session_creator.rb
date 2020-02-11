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
    response_body = JSON.parse(response.body, object_class: OpenStruct)
    status = response_body.error.nil? ? true : false
    puts ERRORS[response_body.error] unless status
    if status
      puts "Session id: " + response_body.data.id.to_s
    end
    [response_body.data.id, status]
  end
end