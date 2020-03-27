class StateHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :state

  field :log, type: Array
end
