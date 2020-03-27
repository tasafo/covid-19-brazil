class State
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :state_history, autosave: true
  has_many :cities

  field :uf, type: String
  field :deaths, type: Integer
  field :confirmed, type: Integer
  field :ibge_code, type: Integer
  field :confirmed_per_100k_inhabitants, type: BigDecimal
  field :date, type: Date
  field :death_rate, type: BigDecimal
  field :estimated_population_2019, type: Integer
end
