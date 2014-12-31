class Note < ActiveRecord::Base
  belongs_to :description, polymorphic: true
end
