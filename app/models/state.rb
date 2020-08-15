class State
  include Mongoid::Document

  field :uf, type: String
  field :name, type: String
  field :deaths, type: Integer, default: 0
  field :cases, type: Integer, default: 0
  field :suspects, type: Integer, default: 0
  field :refuses, type: Integer, default: 0
  field :datetime, type: DateTime

  index({ uf: 1 }, { background: true })

  def self.setup
    covid = Api::Covid19Brazil.new
    data = covid.states

    data.each do |state_data|
      uf = state_data['uf']
      state = State.find_by(uf: uf)

      params = {
        uf: uf,
        name: state_data['state'],
        cases: state_data['cases'],
        deaths: state_data['deaths'],
        suspects: state_data['suspects'],
        refuses: state_data['refuses'],
        datetime: state_data['datetime']
      }

      if state.present?
        state.update_attributes!(params)
      else
        State.create!(params)
      end
    end
  end
end
