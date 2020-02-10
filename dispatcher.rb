require './poker_session_creator'
require './vote_handler'
require './poker_session_status_checker'
require './user_authenticator'
require './reset_handler'

class Dispatcher
    AVAILABLE_OPTIONS = [1,2,3,5,8]

    def initialize(args)
        @arguments = args
    end

    def dispatch
        puts "Please enter Your token"
        token = STDIN.gets.chomp.strip
        authenticator = UserAuthenticator.new
        login_status = authenticator.authenticate(token) 

        if login_status == "SUCCESS"
            case @arguments[0].downcase
            when "start"
                number_of_voting = @arguments[1].to_i
                if number_of_voting > 0
                    poker_session_creator = PokerSessionCreator.new
                    poker_session_id, status = poker_session_creator.create(number_of_voting,token)
                    start_checker(status,poker_session_id)
                else
                     puts "Wrong amount of voting people!"
                end            

            when "vote"
                vote_value = @arguments[1].to_i
                poker_session_id = @arguments[2].to_i
                if AVAILABLE_OPTIONS.include?(vote_value) && poker_session_id > 0
                    vote_handler = VoteHandler.new                
                    status = vote_handler.create(vote_value,poker_session_id,token)
                    start_checker(status,poker_session_id)
                else
                    puts "Wrong arguments!"
                end
            
            when "reset"
                poker_session_id = @arguments[1].to_i
                if poker_session_id > 0 
                    reset_handler = ResetHandler.new
                    status = reset_handler.reset(token,poker_session_id)
                    start_checker(status,poker_session_id)
                else
                    puts "Wrong session id!"
                end
            else
                 puts "Wrong command!"
            end        
        end
    end

    private

    def start_checker(status,poker_session_id)
        if status == "SUCCESS"
            status_checker = PokerSessionStatusChecker.new(poker_session_id,AVAILABLE_OPTIONS)
            status_checker.run
        end
    end
end