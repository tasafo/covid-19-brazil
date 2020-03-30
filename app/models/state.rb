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

  def self.setup
    covid = Api::Covid19Brazil.new
    data = covid.states

    data.each do |state_data|
      state = State.find_by(uf: state_data['uf'])
      
      if state.present?
        state.update!(
          cases: state_data['cases'],
          deaths: state_data['deaths'],
          suspects: state_data['suspects'],
          refuses: state_data['refuses'],
          datetime: state_data['datetime']
        )
      else
        State.create!(
          cases: state_data['cases'],
          deaths: state_data['deaths'],
          suspects: state_data['suspects'],
          refuses: state_data['refuses'],
          datetime: state_data['datetime'],
          uf: state_data['uf'],
          name: state_data['state']
        )
      end
    end
  end
end
