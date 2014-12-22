class SearchController < ApplicationController
  def index
    @search = Resume.search( *Resume.search_params(params) )
        

  end
end
