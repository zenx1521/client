class VoteHandler
  require 'net/http'
  require 'json'

  ERRORS = {
    "ALREADY_VOTED" => "You have voted already",
    "SESSION_FINISHED" => "Session has finished!",
    "SESSION_NOT_UPDATED" => "Session wasn't updated",
    "VOTE_NOT_SAVED" => "Vote wasn't saved",
    "Not Found" => "Session with such id doesn't exist"
  }

  def create(vote_value,poker_session_id,token)
    uri = URI('http://localhost:3000/api/v1/poker_sessions/' + poker_session_id.to_s + '/votes')
    params = {:value => vote_value,:token => token}
    response = Net::HTTP.post_form(uri,params)
    response_body = JSON.parse(response.body, object_class: OpenStruct) 

    if response_body.status == 404
      puts ERRORS[response_body.error]
      return false
    end

    response_body.errors.each {|error| puts ERRORS[error]} if response_body.errors

    if response_body.status == "SUCCESS"
      puts "Vote created successfully"
    end

    return true unless response_body.errors && response_body.errors.any? {|e| e == "SESSION_NOT_UPDATED" || e == "VOTE_NOT_SAVED"}
    false
  end
end