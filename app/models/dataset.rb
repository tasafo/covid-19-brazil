class Dataset
  include HTTParty

  base_uri 'https://brasil.io/api/dataset/covid19'

  def initialize(page)
    @options = { query: { format: 'json', page: page } }
  end

  def caso
    self.class.get('/caso/data', @options)
  end

  def results
    caso['results']
  end

  def count
    caso['count']
  end

  def next
    caso['next']
  end

  def previous
    caso['previous']
  end

  def self.setup
    dataset = Dataset.new(1)
    results = dataset.results
    states_log = results.select{ |h| h['place_type'] == 'state' }.group_by{ |h| h['state']  }
    states = []
    states_log.each do |uf, state_row|
      last_state = state_row.find{ |h| h['is_last'] }

      states << State.create!(uf: last_state['state'],
                    deaths: last_state['deaths'],
                    confirmed: last_state['confirmed'],
                    ibge_code: last_state['city_ibge_code'],
                    confirmed_per_100k_inhabitants: last_state['confirmed_per_100k_inhabitants'],
                    date: last_state['date'],
                    death_rate: last_state['death_rate'],
                    estimated_population_2019: last_state['estimated_population_2019'],
                    state_history: StateHistory.new(log: state_row))
    end

    cities_log = results.select{ |h| h['place_type'] == 'city' }.group_by{ |h| h['city_ibge_code']  }

    cities_log.each do |ibge_code, cities_row|
      last_update = cities_row.find{ |h| h['is_last'] }

      city = City.new(name: last_update['city'],
                      uf: last_update['state'],
                      deaths: last_update['deaths'],
                      confirmed: last_update['confirmed'],
                      ibge_code: last_update['city_ibge_code'],
                      confirmed_per_100k_inhabitants: last_update['confirmed_per_100k_inhabitants'],
                      date: last_update['date'],
                      death_rate: last_update['death_rate'],
                      estimated_population_2019: last_update['estimated_population_2019'],
                      city_history: CityHistory.new(log: cities_row))

      city.upsert

      states.each do |state|
        state.cities << city if state.uf == city.uf
      end
    end
  end
end
