class CityHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :city

  field :log, type: Array
end
