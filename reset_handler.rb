class ResetHandler
  require 'net/http'
  require 'json'

  ERRORS = {
      "ACCESS_DENIED" => "This isn't Your session!",
      "SESSION_NOT_REOPENED" => "Session wasn't reopened",
      "Not Found" => "Session with such id doesn't exist"
  }

  def reset(token,poker_session_id) 
    uri = URI('http://localhost:3000/api/v1/poker_sessions/' + poker_session_id.to_s + '/reset_session')
    params = {:token => token}
    response = Net::HTTP.post_form(uri,params)
    response_body = JSON.parse(response.body, object_class: OpenStruct)
    puts ERRORS[response_body.error] if response_body.error
    if response_body.status == "SUCCESS"
      puts "Session reseted successfully"
      return true
    end
    false
  end
end