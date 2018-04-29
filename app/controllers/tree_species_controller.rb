class TreeSpeciesController < ApplicationController

  # before_action :authenticate_admin!, except: [:index]
  before_action :set_tree_specy, only: [:show, :edit, :update, :destroy]

  # POST /tree_specy/import
  def import_csv
    import_count = TreeSpecy.import_csv(params[:tree_species][:csv_file])
    respond_to do |format|
      format.html { redirect_to tree_species_path,
                    notice: "#{import_count} - New Species Imported" }
    end
  end

  # GET /tree_species
  # GET /tree_species.json
  def index
    @tree_species = TreeSpecy.all.order(species_code: :asc)
    respond_to do |format|
      format.html
      format.json
      format.csv {send_data @tree_species.to_csv,
                  filename: "tree_species-#{Date.today}.csv"}
    end
  end

  # GET /tree_species/1
  # GET /tree_species/1.json
  def show
  end

  # GET /tree_species/new
  def new
    @tree_specy = TreeSpecy.new
  end

  # GET /tree_species/1/edit
  def edit
  end

  # POST /tree_species
  # POST /tree_species.json
  def create
    @tree_specy = TreeSpecy.new(tree_specy_params)

    respond_to do |format|
      if @tree_specy.save
        # format.html { redirect_to @tree_specy, notice: 'Tree specy was successfully created.' }
        format.html { redirect_to tree_species_path, notice: 'Tree specy was successfully created.' }
        format.json { render :show, status: :created, location: @tree_specy }
      else
        format.html { render :new }
        format.json { render json: @tree_specy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tree_species/1
  # PATCH/PUT /tree_species/1.json
  def update
    respond_to do |format|
      if @tree_specy.update(tree_specy_params)
        # format.html { redirect_to @tree_specy, notice: 'Tree specy was successfully updated.' }
        format.html { redirect_to tree_species_path, notice: 'Tree specy was successfully updated.' }
        format.json { render :show, status: :ok, location: @tree_specy }
      else
        format.html { render :edit }
        format.json { render json: @tree_specy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tree_species/1
  # DELETE /tree_species/1.json
  def destroy
    @tree_specy.destroy
    respond_to do |format|
      format.html { redirect_to tree_species_url, notice: 'Tree specy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree_specy
      @tree_specy = TreeSpecy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_specy_params
      params.require(:tree_specy).permit(:species_name, :species_code, :foilage_type, :foilage_strategy, :taxonomy)
    end
end
