class ResumesController < ApplicationController
  def index
     @resumes = Resume.all
     @facets=nil
  end
  def create
    
  end
  def show
  end
  
  def search
    @resumes = Resume.tire.search params[:q]
    
    result=Resume.search(query: params[:q])
   @facets=result.facets
    
    render :action => "index"
  end
end
