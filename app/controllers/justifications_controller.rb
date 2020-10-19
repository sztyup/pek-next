class JustificationsController < EvaluationsController
  before_action :validate_correct_group

  def edit
    @entry_requests = Evaluation.find(params[:evaluation_id]).entry_requests
                                .reject { |er| er.entry_type == EntryRequest::KDO }
                                .sort_by { |a| a.user.full_name }
    redirect_back fallback_location: root_url, alert: t(:no_entry_request) if @entry_requests.empty?
  end

  def update
    entry_requests = EntryRequest.find(params[:entry_requests].keys)
    entry_requests.each do |entry_request|
      entry_request.update(params[:entry_requests][entry_request.id.to_s].permit(:justification))
    end
    redirect_to group_evaluations_current_path(current_group, params[:evaluation_id]),
                notice: t(:edit_successful)
  end
end
