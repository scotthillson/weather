class TemperaturesController < ApplicationController

  before_action :set_temperature, only: [:show, :edit, :update, :destroy]

  def index
    @temperatures = Temperature.all
  end

  def show
  end

  def new
    @temperature = Temperature.new
  end

  def edit
  end

  def create
    @temperature = Temperature.new(temperature_params)
    respond_to do |format|
      if @temperature.save
        format.html { redirect_to @temperature, notice: 'Temperature was successfully created.' }
        format.json { render action: 'show', status: :created, location: @temperature }
      else
        format.html { render action: 'new' }
        format.json { render json: @temperature.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @temperature.update(temperature_params)
        format.html { redirect_to @temperature, notice: 'Temperature was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @temperature.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @temperature.destroy
    respond_to do |format|
      format.html { redirect_to temperatures_url }
      format.json { head :no_content }
    end
  end

  private

  def set_temperature
    @temperature = Temperature.find(params[:id])
  end

  def temperature_params
    params.require(:temperature).permit(:temperature, :latitude, :longitude, :location, :name, :elevation, :precipitation, :altimiter)
  end

end
