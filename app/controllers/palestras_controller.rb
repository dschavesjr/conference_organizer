class PalestrasController < ApplicationController
  before_action :set_palestra, only: %i[ show edit update destroy ]

  # GET /palestras or /palestras.json
  def index
    @palestras = Palestra.all
  end

  # GET /palestras/organize or /palestras/organize.json
  def organize
    palestras = Palestra.all
    palestras = palestras.as_json

    @tracks = manha(palestras)
    palestras = palestras.map {|palestra| palestra unless @tracks.include? palestra}.compact

    @tracks2 = tarde(palestras)
    palestras = palestras.map {|palestra| palestra unless @tracks2.include? palestra}.compact

    @tracksb = manha(palestras)
    palestras = palestras.map {|palestra| palestra unless @tracksb.include? palestra}.compact

    @tracksb2 = tarde(palestras)
    palestras = palestras.map {|palestra| palestra unless @tracksb2.include? palestra}.compact
  end

  # GET /palestras/1 or /palestras/1.json
  def show
  end

  # GET /palestras/new
  def new
    @palestra = Palestra.new
  end

  # GET /palestras/1/edit
  def edit
  end

  # POST /palestras or /palestras.json
  def create
    @palestra = Palestra.new(palestra_params)

    respond_to do |format|
      if @palestra.save
        format.html { redirect_to palestra_url(@palestra), notice: "Palestra was successfully created." }
        format.json { render :show, status: :created, location: @palestra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @palestra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /palestras/1 or /palestras/1.json
  def update
    respond_to do |format|
      if @palestra.update(palestra_params)
        format.html { redirect_to palestra_url(@palestra), notice: "Palestra was successfully updated." }
        format.json { render :show, status: :ok, location: @palestra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @palestra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /palestras/1 or /palestras/1.json
  def destroy
    @palestra.destroy

    respond_to do |format|
      format.html { redirect_to palestras_url, notice: "Palestra was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_palestra
      @palestra = Palestra.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def palestra_params
      params.require(:palestra).permit(:nome, :tempo)
    end

    def manha(palestras, tempo=0, i=0, result=[])
      return result if (tempo == 180 || palestras.difference(result).empty?)
  
      if tempo > 180
        tempo -= palestras[i-1]["tempo"]
        result.delete(palestras[i-1])
      end
  
      while i >= palestras.size
        i = palestras.index(result.pop) + 1
        tempo -= palestras[i-1]["tempo"]
      end
  
      tempo += palestras[i]["tempo"]
      result << palestras[i]
      manha(palestras, tempo, i+1, result)    
    end
  
    def tarde(palestras, tempo=0, i=0, result=[])
      if (tempo == 240 || palestras.difference(result).empty?)
        return result
      end
  
      if tempo > 240
        tempo -= palestras[i-1]["tempo"]
        result.delete(palestras[i-1])
      end
  
      while i >= palestras.size
        i = palestras.index(result.pop) + 1
        tempo -= palestras[i-1]["tempo"]
      end
  
      tempo += palestras[i]["tempo"]
      result << palestras[i]
      tarde(palestras, tempo, i+1, result)    
    end
  
    def sum_time(hours,minutes,minutes_to_sum)
        minutes += minutes + minutes_to_sum
        hours += (minutes.to_i / 60).floor
        minutes = minutes.to_i % 60
        return [hours, minutes]
    end
end
