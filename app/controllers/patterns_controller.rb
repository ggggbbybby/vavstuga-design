class PatternsController < ApplicationController
  before_action :set_pattern, only: [:show, :edit, :update, :destroy, :duplicate]
  authorize_resource

  # GET /patterns
  # GET /patterns.json
  def index
    @public_patterns = Pattern.where(public: true).order(:name)
    @personal_patterns = Pattern.where(public: false, user_id: current_user&.id).order(:name)
    if current_user&.admin?
      @all_patterns = Pattern.all.order(:name)
    end
  end

  # GET /patterns/1
  # GET /patterns/1.json
  def show
  end

  # GET /patterns/new
  def new
    @pattern = Pattern.new
  end

  # GET /patterns/1/edit
  def edit
  end

  # POST /patterns
  # POST /patterns.json
  def create
    @pattern = Pattern.new(pattern_params)
    @pattern.user = current_user || User.first
    @pattern.stripes ||= []
    @pattern.default_colors = {}

    respond_to do |format|
      if @pattern.save
        format.html { redirect_to edit_pattern_path(@pattern.id), notice: 'Pattern was successfully created.' }
        format.json { render :show, status: :created, location: @pattern }
      else
        format.html { render :new }
        format.json { render json: @pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patterns/1
  # PATCH/PUT /patterns/1.json
  def update
    respond_to do |format|
      if @pattern.update(pattern_params)
        format.html { redirect_to @pattern, notice: 'Pattern was successfully updated.' }
        format.json { render :show, status: :ok, location: @pattern }
      else
        format.html { render :edit }
        format.json { render json: @pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patterns/1
  # DELETE /patterns/1.json
  def destroy
    @pattern.destroy
    respond_to do |format|
      format.html { redirect_to patterns_url, notice: 'Pattern was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # POST /patterns/1/duplicate
  def duplicate
    copy = Pattern.duplicate!(@pattern)
    respond_to do |format|
      format.html { redirect_to edit_pattern_path(copy.id), notice: "Duplicated from #{@pattern.name}"}
      format.json { render :show, status: :created, location: copy }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pattern
    @pattern = Pattern.find_by(id: params[:id]) || Pattern.find_by(slug: params[:id])
    @yarn = @pattern&.yarn
    @default_colors = @pattern&.default_colors
  end

  def pattern_params
    params.require(:pattern).permit(:name, :slug, :public, :yarn_id, :vavstuga_product_url, :vavstuga_product_name, :vavstuga_category_url, :vavstuga_category_name, stripes: [:color, :width])
  end
end
