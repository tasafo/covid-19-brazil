class State
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :cities

  field :uf, type: String
  field :name, type: String
  field :deaths, type: Integer
  field :cases, type: Integer
  field :suspects, type: Integer
  field :refuses, type: Integer
  field :datetime, type: DateTime

  index({ uf: 1 }, { background: true })

  def self.setup
    covid = Api::Covid19Brazil.new
    data = covid.states

    results = Api::BrasilIo.dataset(1)
    states_log = results.select { |h| h['place_type'] == 'state' && h['is_last'] }

    data.each do |state_data|
      state = State.find_by(uf: state_data['uf'])

      state_log = states_log.find { |h| h['state'] == state_data['uf'] }

      updated_params = {
        cases: state_log['confirmed'],
        deaths: state_log['deaths'],
        suspects: state_data['suspects'],
        refuses: state_data['refuses'],
        datetime: state_data['datetime']
      }

      created_params = {
        uf: state_data['uf'],
        name: state_data['state']
      }

      if state.present?
        state.update!(updated_params)
      else
        State.create!(created_params.merge(updated_params))
      end
    end
  end
end
