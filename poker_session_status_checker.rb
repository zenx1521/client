class PokerSessionStatusChecker
    require 'net/http'
    require 'json'

    def initialize(poker_session_id,opts)
        @poker_session_id = poker_session_id
        @opts = opts
    end

    def run 
        prev = -1
        loop do 
            uri = URI('http://localhost:3000/api/v1/poker_sessions/' + @poker_session_id.to_s + '/return_stats')
            response =  Net::HTTP.get(uri)
            response_json = JSON.parse(response, object_class: OpenStruct)
            data_json = JSON.parse(response_json.data, object_class: OpenStruct)            
            votes_count = data_json.votes_count
            
            if(prev != data_json.votes_count)
                voting_amount = data_json.number_of_voting
                puts '[' + '#'*votes_count*2 + ' '*(voting_amount-votes_count)*2 + ']'
                prev = votes_count
            end 

            if data_json.finished
                count_statistics(data_json)
                break
            end

            sleep(2)
        end
    end

    def count_statistics(data)

        statistics = {}

        @opts.each do |option|
            statistics[option] = []
            statistics[option][0] = ""
            statistics[option][1] = 0
        end

        data.votes.each do |vote| 
            statistics[vote.value][0] += vote.user.name + ' '
            statistics[vote.value][1] += 1 
        end 
        
        statistics.each do |key,value|            
            if value[0] == ""
                puts key.to_s + ": -"
            else
                puts key.to_s + ": " + value[0]
            end 
        end
        for_draw_check =  statistics.map { |key,value| value[1]}.sort { |left,right| right <=> left }
        if(for_draw_check[0] == for_draw_check[1])
            puts "There was a draw!!!"
        end    
    end
end