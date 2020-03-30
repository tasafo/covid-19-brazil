class Dataset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :results, type: Array
end
