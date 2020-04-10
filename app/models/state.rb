class State
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :cities

  field :uf, type: String
  field :name, type: String
  field :deaths, type: Integer, default: 0
  field :cases, type: Integer, default: 0
  field :suspects, type: Integer, default: 0
  field :refuses, type: Integer, default: 0
  field :datetime, type: DateTime

  index({ uf: 1 }, { background: true })

  def self.setup(dataset = nil)
    results = dataset.nil? ? Api::BrasilIo.dataset(1) : dataset
    states_log = results.select { |h| h['place_type'] == 'state' && h['is_last'] }

    covid = Api::Covid19Brazil.new
    data = covid.states

    data.each do |state_data|
      state = State.find_by(uf: state_data['uf'])

      state_log = states_log.find { |h| h['state'] == state_data['uf'] }

      params = {
        uf: state_data['uf'],
        name: state_data['state'],
        cases: state_log['confirmed'],
        deaths: state_log['deaths'],
        suspects: state_data['suspects'],
        refuses: state_data['refuses'],
        datetime: state_data['datetime']
      }

      if state.present?
        state.update!(params)
      else
        State.create!(params)
      end
    end
  end
end
