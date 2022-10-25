class PalestrasController < ApplicationController
  before_action :set_palestra, only: %i[ show edit update destroy ]

  # GET /palestras or /palestras.json
  def index
    @palestras = Palestra.all
  end

  # GET /palestras/organize or /palestras/organize.json
  def organize
    @resultado = Evento.organizado
  end

  # GET /palestras/sendfile
  def sendfile
  end

  # POST /palestras/add
  def add
    arquivo_param = params.permit(:arquivo)
    unless arquivo_param[:arquivo].blank?
      @evento_organizado = request_api('http://localhost:3000/api/v1/palestras', arquivo_param[:arquivo].read)
    end
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

    def request_api(url, json)
      res = RestClient.post(url,
        {
          arquivo: json,
          multipart: true
        })
      JSON.parse(res.body) if res.code == 200
    end

end
