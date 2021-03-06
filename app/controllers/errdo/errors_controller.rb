require "slim"

module Errdo
  class ErrorsController < Errdo::ApplicationController

    include Errdo::Helpers::ViewsHelper
    helper_method :user_show_string, :user_show_path

    before_action :authorize_user

    def index
      @errors = Errdo::Error.order(last_occurred_at: :desc).includes(:last_experiencer).page params[:page]
    end

    def show
      @error = Errdo::Error.find(params[:id])
      @occurrence = selected_occurrence(@error)
    end

    def update
      @error = Errdo::Error.find(params[:id])
      if @error.update(error_params)
        flash[:notice] = "Success updating status!"
      else
        flash[:alert] = "Updating failed"
      end
      @occurrence = selected_occurrence(@error)
      render :show
    end

    private

    def authorize_user
      @authorization_adapter ||= nil
      @authorization_adapter.try(:authorize, params["action"], Errdo::Error)
    end

    def error_params
      params.require(:error).permit(:status)
    end

    def selected_occurrence(error)
      if params[:occurrence_id]
        Errdo::ErrorOccurrence.find(params[:occurrence_id])
      else
        error.error_occurrences.last
      end
    end

  end
end
