class Resume < ActiveRecord::Base
  include ElasticSearchable
  has_many :competencies
  accepts_nested_attributes_for :competencies
end
