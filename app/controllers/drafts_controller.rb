class DraftsController < ApplicationController
    before_action :set_draft, only: [:show, :edit, :update, :destroy]
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
      @draft = Draft.with_defaults
    end

    def create
      @draft = Draft.with_defaults
      @draft.user = current_user || User.first
      params = draft_params

      # don't overwrite default draft values, we need those
      @draft.draft.each { |k, v| params[:draft][k] ||= v }
      if @draft.update(params)
        redirect_to edit_draft_path(@draft.id), notice: 'Draft was successfully created.'
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

    def destroy
      @draft.destroy
      redirect_to drafts_path, notice: 'Draft was successfully destroyed'
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
