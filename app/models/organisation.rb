class Organisation < ActiveRecord::Base

  validates :slug,
            :name,
            :orgnaisation_type,
            :searchable,
             presence: true
end
