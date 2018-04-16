class TreeMeasurementsController < ApplicationController

  before_action :authenticate_admin!, except: [:index]
  before_action :set_tree_measurement,
                only: [:show, :edit, :update, :destroy]

  # POST /tree_measurements/import
  def import_csv
    import_count = TreeMeasurement.import_csv(params[:tree_measurements][:csv_file])
    respond_to do |format|
      format.html { redirect_to tree_measurements_path,
                    notice: "#{import_count} - New Tree Measurements Imported" }
    end
  end

  # GET /tree_measurements
  # GET /tree_measurements.json
  def index
    @tree_measurements = TreeMeasurement.joins(:tree_plot, :tree_specy)
                          .includes(:tree_plot, :tree_specy)
                          .order('measurement_date desc')
                          .references(:tree_plot)
                          # .order('tree_plot.elevation_m asc')
    respond_to do |format|
      format.html
      format.json
      format.csv {send_data @tree_measurements.to_csv,
                  filename: "lets_tree_measurements-#{Date.today}.csv"}
    end
  end

  # GET /tree_measurements/1
  # GET /tree_measurements/1.json
  def show
  end

  # GET /tree_measurements/new
  def new
    @tree_measurement = TreeMeasurement.new
  end

  # GET /tree_measurements/1/edit
  def edit
  end

  # POST /tree_measurements
  # POST /tree_measurements.json
  def create
    @tree_measurement = TreeMeasurement.new(tree_measurement_params)

    respond_to do |format|
      if @tree_measurement.save
        # format.html { redirect_to @tree_measurement,
        #                       notice: 'Tree measurement was successfully created.' }
        format.html { redirect_to tree_measurements_path,
                              notice: 'Tree measurement was successfully created.' }
        format.json { render :show, status: :created,
                              location: @tree_measurement }
      else
        format.html { render :new }
        format.json { render json: @tree_measurement.errors,
                              status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tree_measurements/1
  # PATCH/PUT /tree_measurements/1.json
  def update
    respond_to do |format|
      if @tree_measurement.update(tree_measurement_params)
        # format.html { redirect_to @tree_measurement,
        #               notice: 'Tree measurement was successfully updated.' }
        format.html { redirect_to tree_measurements,
                      notice: 'Tree measurement was successfully updated.' }
        format.json { render :show, status: :ok, location: @tree_measurement }
      else
        format.html { render :edit }
        format.json { render json: @tree_measurement.errors,
                              status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tree_measurements/1
  # DELETE /tree_measurements/1.json
  def destroy
    @tree_measurement.destroy
    respond_to do |format|
      format.html { redirect_to tree_measurements_url,
                    notice: 'Tree measurement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree_measurement
      @tree_measurement = TreeMeasurement.includes(:tree_plot).
                                          includes(:tree_specy).
                                          find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_measurement_params
      params.require(:tree_measurement).permit(:circumfrence_cm,
        :measurement_date, :subquadrat, :tree_label, :tree_specy_id,
        :tree_plot_id)
    end
end
