class DraftsController < ApplicationController
    before_action :set_draft, only: [:show, :edit, :update]
    authorize_resource

    # GET /drafts
    def index
      @drafts = Draft.order(:name)
    end

    def show
      # render @draft
    end

    def edit
      # render @draft + editing form
    end

    def new
      @draft = Draft.new
    end

    def create
      @draft = Draft.new(draft_params)
      @draft.user = current_user || User.first

      if @draft.save
        redirect_to draft_path(@draft.id), notice: 'Draft was successfully created.'
      else
        render :new
      end
    end

    def update
      # deserialize fields that were serialized on the client
      params = draft_params
      ['warp', 'warp_colors', 'weft', 'weft_colors', 'tieup'].each do |serialized_field|
        params[:draft][serialized_field] = JSON.parse(params[:draft][serialized_field])
      end

      if @draft.update(params)
        redirect_to draft_path(@draft.id), notice: 'Draft was successfully updated.'
      else
        render :edit, notice: 'Draft could not be updated'
      end
    end

    private
    def set_draft
      @draft = Draft.find_by(id: params[:id]) || Draft.find_by(slug: params[:id])
      @yarn = @draft&.yarn
    end

    def draft_params
        params.require(:draft).permit(*Draft.permitted)
    end

end
