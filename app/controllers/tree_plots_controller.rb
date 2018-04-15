class TreePlotsController < ApplicationController

  before_action :authenticate_admin!, except: [:index]
  before_action :set_tree_plot, only: [:show, :edit, :update, :destroy]

  # GET /tree_plots
  # GET /tree_plots.json
  def index
    @tree_plots = TreePlot.all
    respond_to do |format|
      format.html
      format.json
      format.csv {send_data @tree_plots.to_csv,
                  filename: "tree_plots-#{Date.today}.csv"}
    end
  end

  # GET /tree_plots/1
  # GET /tree_plots/1.json
  def show
  end

  # GET /tree_plots/new
  def new
    @tree_plot = TreePlot.new
  end

  # GET /tree_plots/1/edit
  def edit
  end

  # POST /tree_plots
  # POST /tree_plots.json
  def create
    @tree_plot = TreePlot.new(tree_plot_params)

    respond_to do |format|
      if @tree_plot.save
        format.html { redirect_to @tree_plot, notice: 'Tree plot was successfully created.' }
        format.json { render :show, status: :created, location: @tree_plot }
      else
        format.html { render :new }
        format.json { render json: @tree_plot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tree_plots/1
  # PATCH/PUT /tree_plots/1.json
  def update
    respond_to do |format|
      if @tree_plot.update(tree_plot_params)
        format.html { redirect_to @tree_plot, notice: 'Tree plot was successfully updated.' }
        format.json { render :show, status: :ok, location: @tree_plot }
      else
        format.html { render :edit }
        format.json { render json: @tree_plot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tree_plots/1
  # DELETE /tree_plots/1.json
  def destroy
    @tree_plot.destroy
    respond_to do |format|
      format.html { redirect_to tree_plots_url, notice: 'Tree plot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree_plot
      @tree_plot = TreePlot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_plot_params
      params.require(:tree_plot).permit(:plot_name, :plot_code, :elevation_m,
        :latitude, :longitude, :transect_id)
    end
end
