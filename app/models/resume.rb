class Resume < ActiveRecord::Base
  include ElasticSearchable
    
#  mapping do
#    indexes :name , type: 'string'
#    property :email, type: 'string', analyzer: 'keyword'
#    indexes :telephone, type: 'string'    
#  end
#  
#def self.search(params)
#    Resume.tire.search(load: true, page: params[:page], per_page: 10) do |s|
#      s.query { string params[:query]} if params[:query].present?
#      s.filter :terms, params[:with] if params[:with]
##      s.facet "name" do
##        terms :name
##      end
#    end
#  end  
end
