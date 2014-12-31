class Resume < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  has_one :note, as: :description
  has_many :employer_histories
  
  mapping do
    indexes :name , type: 'string'
    indexes :email, type: 'string'
    indexes :country, type: 'string'
    indexes :telephone, type: 'string'    
  end
  
def self.search(params)
    tire.search(load: true, page: params[:page], per_page: 10) do |s|
      s.query { string params[:query]} if params[:query].present?
      s.facet "name" do
        terms :name
      end
      s.facet "country" do
        terms :country
      end
    end
  end  
end
