class TransectAdminEditorsController < ApplicationController
  before_action :set_transect_admin_editor, only: [:show, :edit, :update, :destroy]

  # GET /transect_admin_editors
  # GET /transect_admin_editors.json
  def index
    @transect_admin_editors = TransectAdminEditor.all
    respond_to do |format|
      format.html
      format.json
      format.csv {send_data @transect_admin_editors.to_csv,
                  filename: "transect_admin_editors-#{Date.today}.csv"}
    end
  end

  # GET /transect_admin_editors/1
  # GET /transect_admin_editors/1.json
  def show
  end

  # GET /transect_admin_editors/new
  def new
    @transect_admin_editor = TransectAdminEditor.new
  end

  # GET /transect_admin_editors/1/edit
  def edit
  end

  # POST /transect_admin_editors
  # POST /transect_admin_editors.json
  def create
    @transect_admin_editor = TransectAdminEditor.new(transect_admin_editor_params)

    respond_to do |format|
      if @transect_admin_editor.save
        format.html { redirect_to @transect_admin_editor, notice: 'Transect admin editor was successfully created.' }
        format.json { render :show, status: :created, location: @transect_admin_editor }
      else
        format.html { render :new }
        format.json { render json: @transect_admin_editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transect_admin_editors/1
  # PATCH/PUT /transect_admin_editors/1.json
  def update
    respond_to do |format|
      if @transect_admin_editor.update(transect_admin_editor_params)
        format.html { redirect_to @transect_admin_editor, notice: 'Transect admin editor was successfully updated.' }
        format.json { render :show, status: :ok, location: @transect_admin_editor }
      else
        format.html { render :edit }
        format.json { render json: @transect_admin_editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transect_admin_editors/1
  # DELETE /transect_admin_editors/1.json
  def destroy
    @transect_admin_editor.destroy
    respond_to do |format|
      format.html { redirect_to transect_admin_editors_url, notice: 'Transect admin editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transect_admin_editor
      @transect_admin_editor = TransectAdminEditor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transect_admin_editor_params
      params.require(:transect_admin_editor).permit(:transect_id, :admin_id)
    end
end
