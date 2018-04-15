class TransectsController < ApplicationController

  before_action :authenticate_admin!, except: [:index]
  before_action :set_transect, only: [:show, :edit, :update, :destroy]

  # GET /transects
  # GET /transects.json
  def index
    @transects = Transect.all
    respond_to do |format|
      format.html
      format.json
      format.csv  { send_data @transects.to_csv,
                    filename: "transects-#{Date.today}.csv"}
    end
  end

  # GET /transects/1
  # GET /transects/1.json
  def show
  end

  # GET /transects/new
  def new
    @transect = Transect.new
  end

  # GET /transects/1/edit
  def edit
  end

  # POST /transects
  # POST /transects.json
  def create
    @transect = Transect.new(transect_params)

    respond_to do |format|
      if @transect.save
        format.html { redirect_to @transect, notice: 'Transect was successfully created.' }
        format.json { render :show, status: :created, location: @transect }
      else
        format.html { render :new }
        format.json { render json: @transect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transects/1
  # PATCH/PUT /transects/1.json
  def update
    respond_to do |format|
      if @transect.update(transect_params)
        format.html { redirect_to @transect, notice: 'Transect was successfully updated.' }
        format.json { render :show, status: :ok, location: @transect }
      else
        format.html { render :edit }
        format.json { render json: @transect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transects/1
  # DELETE /transects/1.json
  def destroy
    @transect.destroy
    respond_to do |format|
      format.html { redirect_to transects_url, notice: 'Transect was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transect
      @transect = Transect.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transect_params
      params.require(:transect).permit(:transect_name, :transect_code, :target_slope, :target_aspect)
    end
end
