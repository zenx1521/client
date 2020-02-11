class VoteHandler
  require 'net/http'
  require 'json'

  ERRORS = {
    "ALREADY_VOTED" => "You have voted already",
    "SESSION_FINISHED" => "Session has finished!",
    "SESSION_NOT_UPDATED" => "Session wasn't updated",
    "VOTE_NOT_SAVED" => "Vote wasn't saved"
  }

  def create(vote_value,poker_session_id,token)
    uri = URI('http://localhost:3000/api/v1/poker_sessions/' + poker_session_id.to_s + '/votes')
    params = {:value => vote_value,:token => token}
    response = Net::HTTP.post_form(uri,params)
    response_body = JSON.parse(response.body, object_class: OpenStruct) 
    puts "Wrong session id" if response_body.status == 404
    response_body.errors.each {|error| puts ERRORS[error]} if response_body.errors
    if !response_body.errors.include? ["SESSION_NOT_UPDATED","VOTE_NOT_SAVED"]
        return true        
    end
    return false
  end
end