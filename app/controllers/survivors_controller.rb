class SurvivorsController < ApplicationController
  before_action :set_survivor, only: [:show, :update, :update_location, :update_infected]

  # GET /survivors
  def index
    @survivors = Survivor.where("infected < 3")

    render json: @survivors
  end

  # GET /survivors/1
  def show
    if @survivor.infected < 3
      render json: @survivor
    else
      render json: {
            success: false,
            msg: "Server: Warning!!! Warning!!! #{@survivor.name} is a ZUMBI!!!"
          }.to_json, status: :unprocessable_entity
    end
  end

  # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)

    @survivor.infected = 0
   

    if @survivor.save
      render json: @survivor, status: :created, location: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survivors/1
  def update
    if @survivor.update(survivor_params)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def update_location
    if @survivor.update(survivor_params_location)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def update_infected
    @survivor.infected = @survivor.infected + 1
    if @survivor.update(survivor_params_infected)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def trade
    friend_id = params[:id]
    survivor_id = survivor_params_trade.to_hash['trade']['survivor_id']
    my_items = survivor_params_trade.to_hash['trade']['my_items']
    friend_items = survivor_params_trade.to_hash['trade']['friend_items']

    equiTrade = (my_items['ammunition'] * 1 + my_items['food'] * 3 + my_items['medication'] * 2 + my_items['water'] * 4) == (friend_items['ammunition'] * 1 + friend_items['food'] * 3 + friend_items['medication'] * 2 + friend_items['water'] * 4)
    if equiTrade
      me_infected = Survivor.where("id = ? and infected >=3", survivor_id).count
      friend_infected = Survivor.where("id = ? and infected >= 3", friend_id).count
      if me_infected == 0 and friend_infected == 0
        friend_has_items = Survivor.where("id = ? and ammunition_amount >= ? and food_amount >= ? and medication_amount >= ? and water_amount >= ?", survivor_id, my_items['ammunition'], my_items['food'], my_items['medication'], my_items['water']).count
        me_has_items = Survivor.where("id = ? and ammunition_amount >= ? and food_amount >= ? and medication_amount >= ? and water_amount >= ?", survivor_id, friend_items['ammunition'], friend_items['food'], friend_items['medication'], friend_items['water']).count
        if friend_has_items == 1 and me_has_items == 1
          @me = Survivor.find(survivor_id)
          @friend = Survivor.find(friend_id)
          @me.update(ammunition_amount: @me.ammunition_amount + friend_items['ammunition'] - my_items['ammunition'],
                    food_amount: @me.food_amount + friend_items['food'] - my_items['food'],
                    water_amount: @me.water_amount + friend_items['water'] - my_items['water'],
                    medication_amount: @me.medication_amount + friend_items['medication'] - my_items['medication'])
          @friend.update(ammunition_amount: @friend.ammunition_amount + my_items['ammunition'] - friend_items['ammunition'],
                    food_amount: @friend.food_amount + my_items['food'] - friend_items['food'],
                    water_amount: @friend.water_amount + my_items['water'] - friend_items['water'],
                    medication_amount: @friend.medication_amount + my_items['medication'] - friend_items['medication'])
          render json: {
            success: true,
            msg: "Server: Trade Completed!!"
          }.to_json, status: 200
        else
          render json: {
            success: false,
            msg: "Server: Promises cannot enter the balance of trade. You need to have what you promise to give!!"
          }.to_json, status: :unprocessable_entity
        end
      else
        render json: {
            success: false,
            msg: "Server: The only things the dead can exchange are whining."
          }.to_json, status: :unprocessable_entity
      end
    else
      render json: {
            success: false,
            msg: "Server: Nothing can be obtained without a kind of sacrifice. To obtain something one must offer something in return for equivalent value. This is the basic principle of alchemy, the Equivalent Exchange Law."
          }.to_json, status: :unprocessable_entity
    end
  end

  def report_zombie

    zombie = ((Survivor.where("infected >= 3").count + 0.0) / Survivor.count)*100
    render json: {
            success: true,
            value: zombie,
            msg: "Server: We have #{zombie}% ZOMBIES..."
          }.to_json, status: 200
  end

  def report_survivor
    
    survivor = ((Survivor.where("infected < 3").count + 0.0) / Survivor.count)*100
    render json: {
            success: true,
            value: survivor,
            msg: "Server: We have #{survivor}% survivors...Stay Strong!!!"
          }.to_json, status: 200
  end

  def report_resource
  
    ammunition = Survivor.where("infected < 3").calculate(:average, 'ammunition_amount')
    food = Survivor.where("infected < 3").calculate(:average, 'food_amount')
    medication = Survivor.where("infected < 3").calculate(:average, 'medication_amount')
    water = Survivor.where("infected < 3").calculate(:average, 'water_amount')
    render json: {
            success: true,
            values: {
              ammunition: ammunition.to_f,
              food: food.to_f,
              water: water.to_f,
              medication: medication.to_f
            },
            msg: "Server: This is the country sittuation...
            Ammunition/Survivor: #{ammunition}
            Food/Survivor: #{food}
            Medication/Survivor: #{medication}
            Water/Survivor: #{water}"
          }.to_json, status: 200
  end

  def report_lost
    x = 0
    lost = Survivor.where("infected >= 3")
    lost.each do |cobaia|
    x = x + (cobaia.ammunition_amount * 1 + cobaia.food_amount * 3 + cobaia.medication_amount * 2 + cobaia.water_amount * 4)
    end
    render json: {
            success: true,
            value: x,
            msg: "points #{x}" 
          }.to_json, status: 200 
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survivor
      @survivor = Survivor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def survivor_params
      params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude, :infected, :water_amount, :ammunition_amount, :medication_amount, :food_amount)
    end

    def survivor_params_location
      params.require(:survivor).permit(:latitude, :longitude)
    end

    def survivor_params_infected
      params.require(:survivor).permit()
    end

    def survivor_params_trade
      params.permit!
    end

end
