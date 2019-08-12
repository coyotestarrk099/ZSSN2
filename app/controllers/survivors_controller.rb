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
      render json: "Warning!!! Warning!!! #{@survivor.name} is a ZUMBI!!!"
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

  def report_zombie

    zombie = ((Survivor.where("infected >= 3").count + 0.0) / Survivor.count)*100
    render json: "Server: We have #{zombie}% ZOMBIES..."
  end

  def report_survivor
    
    survivor = ((Survivor.where("infected < 3").count + 0.0) / Survivor.count)*100
    render json: "Server: We have #{survivor}% survivors...Stay Strong!!!"
  end

  def report_resource
  
    ammunition = Survivor.where("infected < 3").calculate(:average, 'ammunition_amount')
    food = Survivor.where("infected < 3").calculate(:average, 'food_amount')
    medication = Survivor.where("infected < 3").calculate(:average, 'medication_amount')
    water = Survivor.where("infected < 3").calculate(:average, 'water_amount')
    render json: "Server: This is the country sittuation...
    Ammunition/Survivor: #{ammunition}
    Food/Survivor: #{food}
    Medication/Survivor: #{medication}
    Water/Survivor: #{water}"
  end

  def report_lost
    x = 0
    lost = Survivor.where("infected >= 3")
    lost.each do |cobaia|
    x = x + (cobaia.ammunition_amount * 1 + cobaia.food_amount * 3 + cobaia.medication_amount * 2 + cobaia.water_amount * 4)
    end
    render json: "#{x}"    
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

end
