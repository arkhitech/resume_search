class EmployerHistory < ActiveRecord::Base
  
  belongs_to :resume
  has_one :note, as: :description
end
