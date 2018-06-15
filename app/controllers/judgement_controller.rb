class JudgementController < ApplicationController
  before_action :require_login
  before_action :require_privileges_of_rvt

  def index
    semester = SystemAttribute.semester.to_s
    @evaluations = Evaluation.where(date: semester).page(params[:page]).decorate
  end

end
