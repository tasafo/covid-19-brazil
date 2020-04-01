class City
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :city_history, autosave: true

  field :name, type: String
  field :uf, type: String
  field :deaths, type: Integer
  field :confirmed, type: Integer
  field :ibge_code, type: Integer
  field :confirmed_per_100k_inhabitants, type: BigDecimal
  field :date, type: Date
  field :death_rate, type: BigDecimal
  field :estimated_population_2019, type: Integer

  def self.setup
    results = Api::BrasilIo.dataset(1)
    cities_log = results.select{ |h| h['place_type'] == 'city' }.group_by{ |h| h['city_ibge_code']  }

    cities_log.each do |ibge_code, cities_row|
      last_update = cities_row.find{ |h| h['is_last'] }

      params = {
        name: last_update['city'],
        uf: last_update['state'],
        deaths: last_update['deaths'] || 0,
        confirmed: last_update['confirmed'] || 0,
        ibge_code: last_update['city_ibge_code'],
        confirmed_per_100k_inhabitants: last_update['confirmed_per_100k_inhabitants'] || 0,
        date: last_update['date'],
        death_rate: last_update['death_rate'] || 0,
        estimated_population_2019: last_update['estimated_population_2019'] || 0,
        city_history: CityHistory.new(log: cities_row)
      }

      city = City.find_by(ibge_code: last_update['city_ibge_code'])

      unless city.present?
        City.create!(params)
      end
    end
  end
end
