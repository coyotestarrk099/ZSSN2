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
            msg: "Lori: Warning!!! Warning!!! #{@survivor.name} is a ZUMBI!!!"
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

  def trade
    result = VerifyTradeService.new({
      friend_id: params[:id],
      survivor_id: survivor_params_trade.to_hash['trade']['survivor_id'],
      my_items: survivor_params_trade.to_hash['trade']['my_items'],
      friend_items: survivor_params_trade.to_hash['trade']['friend_items']
    }).charge

    if (result == 1)
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
        msg: "Lori: Trade Completed!!"
      }.to_json, status: 200
    else
      if (result == 2)
        msg = "Lori: Promises cannot enter the balance of trade. You need to have what you promise to give!!"
      elsif (result == 3)
        msg = "Lori: The only things the dead can exchange are whining."
      elsif (result == 4)
        msg = "Lori: Nothing can be obtained without a kind of sacrifice. To obtain something one must offer something in return for equivalent value. This is the basic principle of alchemy, the Equivalent Exchange Law."
      end
      render json: {
          success: false,
          msg: msg
        }.to_json, status: :unprocessable_entit
    end
  end

  def report_zombie

    zombie = ((Survivor.where("infected >= 3").count + 0.0) / Survivor.count)*100
    render json: {
            success: true,
            value: zombie,
            msg: "Lori: We have #{zombie}% ZOMBIES..."
          }.to_json, status: 200
  end

  def report_survivor
    
    survivor = ((Survivor.where("infected < 3").count + 0.0) / Survivor.count)*100
    render json: {
            success: true,
            value: survivor,
            msg: "Lori: We have #{survivor}% survivors...Stay Strong!!!"
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
            msg: "Lori: This is the country sittuation...
            Ammunition/Survivor: #{ammunition}
            Food/Survivor: #{food}
            Medication/Survivor: #{medication}
            Water/Survivor: #{water}"
          }.to_json, status: 200
  end

  def report_lost
    x = 0
    grimes = Survivor.where("infected >= 3")
    grimes.each do |carl|
    x = x + (carl.ammunition_amount * 1 + carl.food_amount * 3 + carl.medication_amount * 2 + carl.water_amount * 4)
    end
    render json: {
            success: true,
            value: x,
            msg: "Lori: #{x} resource points lost for infection" 
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
