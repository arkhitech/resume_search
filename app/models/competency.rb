class Competency < ActiveRecord::Base
  include ElasticSearchable
    belongs_to :resume
end
