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
    @resumes = Resume.all
  end

  # GET /resume/1
  # GET /resumes/1.json
  def show
  end

  # GET /resume/new
  def new
    @resume = Resume.new
  end

  # GET /resume/1/edit
  def edit
  end

  # POST /resume
  # POST /resume.json
  def create
    @resume = Resume.new(resume_params)

    respond_to do |format|
      if @resume.save
        format.html { redirect_to @resume, notice: 'Resume was successfully created.' }
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end


  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resume_params
      params.require(:resume).permit(:name, :telephone, :email, :country)
    end
  
end
