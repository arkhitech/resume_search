class ResumesController < ApplicationController
#  def index
#     @resumes = Resume.all
#     names=@resumes.map(&:name).join(",")
#     result=Resume.search(query: names)
#     @facets=result.facets
#  end
#  def create
#    
#  end
#  def show
#  end
#  
#  def search
#    #@resumes = Resume.tire.search params[:q]
#    
#    search = Resume.search(search_params)
#    @facets = search.facets
#    @resumes = search.results
#    
#    render :action => "index"
#  end
#  
#  def search_params
#    params.permit(:q, with: [:location, :email])
#  end
#  

  
  
  
  before_action :set_resume, only: [:show, :edit]

  # GET /people
  # GET /people.json
  def index
#     @resumes = Resume.all
#     names=@resumes.map(&:name).join(",")
     @resumes=Resume.search(params)
     @facets= @resumes.facets
  end
  def create
    
  end

  # GET /resume/1
  # GET /resumes/1.json
  def show
  end
  
#  def search
#    @resumes = Resume.tire.search params[:q]
#    
#    result=Resume.search(query: params[:q])
#   @facets=result.facets
#    
#    render :action => "index"
#  end
end
