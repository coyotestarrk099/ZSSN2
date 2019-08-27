class VerifyTradeService
    def initialize(params={})
        @friend_id = params[:friend_id]
        @survivor_id = params[:survivor_id]
        @my_items = params[:my_items]
        @friend_items = params[:friend_items]
        @me = Survivor.find(@survivor_id)
        @friend = Survivor.find(@friend_id)
    end

    def charge
        verify_trade
    end

    private

    def verify_trade
        equiTrade = (@my_items['ammunition'] * 1 + @my_items['food'] * 3 + @my_items['medication'] * 2 + @my_items['water'] * 4) == (@friend_items['ammunition'] * 1 + @friend_items['food'] * 3 + @friend_items['medication'] * 2 + @friend_items['water'] * 4)
        if equiTrade
        me_infected = Survivor.where("id = ? and infected >=3", @survivor_id).count
        friend_infected = Survivor.where("id = ? and infected >= 3", @friend_id).count
        if me_infected == 0 and friend_infected == 0
            friend_has_items = Survivor.where("id = ? and ammunition_amount >= ? and food_amount >= ? and medication_amount >= ? and water_amount >= ?", @survivor_id, @my_items['ammunition'], @my_items['food'], @my_items['medication'], @my_items['water']).count
            me_has_items = Survivor.where("id = ? and ammunition_amount >= ? and food_amount >= ? and medication_amount >= ? and water_amount >= ?", @survivor_id, @friend_items['ammunition'], @friend_items['food'], @friend_items['medication'], @friend_items['water']).count
            if friend_has_items == 1 and me_has_items == 1
                @me = Survivor.find(@survivor_id)
                @friend = Survivor.find(@friend_id)
                @me.update(ammunition_amount: @me.ammunition_amount + @friend_items['ammunition'] - @my_items['ammunition'],
                            food_amount: @me.food_amount + @friend_items['food'] - @my_items['food'],
                            water_amount: @me.water_amount + @friend_items['water'] - @my_items['water'],
                            medication_amount: @me.medication_amount + @friend_items['medication'] - @my_items['medication'])
                @friend.update(ammunition_amount: @friend.ammunition_amount + @my_items['ammunition'] - @friend_items['ammunition'],
                            food_amount: @friend.food_amount + @my_items['food'] - @friend_items['food'],
                            water_amount: @friend.water_amount + @my_items['water'] - @friend_items['water'],
                            medication_amount: @friend.medication_amount + @my_items['medication'] - @friend_items['medication'])
                1
            else
                2
            end
        else
            3
        end
        else
            4
        end
    end
         
end