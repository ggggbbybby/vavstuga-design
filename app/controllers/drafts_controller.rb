class DraftsController < ApplicationController
    before_action :set_draft, only: [:show]
    authorize_resource

    # GET /drafts
    def index
      @drafts = Draft.order(:name)
    end

    def show
      # render @draft 
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


    private
    def set_draft
        @draft = Draft.find_by(id: params[:id]) || Draft.find_by(slug: params[:id])
    end

    def draft_params
        params.require(:draft).permit(*Draft.permitted)
    end

end
