class EmployerHistoriesController < ApplicationController
  
  def index
     @histories = EmployerHistory.where(resume_id: params[:resume_id])
  end
  
end
