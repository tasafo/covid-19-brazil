class City
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :city_history, autosave: true
  belongs_to :state

  field :name, type: String
  field :uf, type: String
  field :deaths, type: Integer
  field :confirmed, type: Integer
  field :ibge_code, type: Integer
  field :confirmed_per_100k_inhabitants, type: BigDecimal
  field :date, type: Date
  field :death_rate, type: BigDecimal
  field :estimated_population_2019, type: Integer
end
