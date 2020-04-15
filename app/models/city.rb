class City
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :city_history, autosave: true

  field :name, type: String
  field :uf, type: String
  field :deaths, type: Integer, default: 0
  field :confirmed, type: Integer, default: 0
  field :ibge_code, type: Integer
  field :confirmed_per_100k_inhabitants, type: BigDecimal, default: 0
  field :date, type: Date
  field :death_rate, type: BigDecimal, default: 0
  field :estimated_population_2019, type: Integer, default: 0
  field :coordinates, type: Array

  index({ ibge_code: 1 }, { background: true })
  index({ uf: 1 }, { background: true })

  def self.setup(dataset = nil)
    results = dataset.nil? ? Api::BrasilIo.dataset(1) : dataset

    cities_log = results.select { |h| h['place_type'] == 'city' }.group_by{ |h| h['city_ibge_code'] }

    cities_log.each do |ibge_code, cities_row|
      last_update = cities_row.find { |h| h['is_last'] }

      updated_params = {
        deaths: last_update['deaths'],
        confirmed: last_update['confirmed'],
        confirmed_per_100k_inhabitants: last_update['confirmed_per_100k_inhabitants'],
        date: last_update['date'],
        death_rate: last_update['death_rate']
      }

      created_params = {
        name: last_update['city'],
        uf: last_update['state'],
        ibge_code: last_update['city_ibge_code'],
        estimated_population_2019: last_update['estimated_population_2019'],
        city_history: CityHistory.new(log: cities_row)
      }

      city = City.find_by(ibge_code: last_update['city_ibge_code'])

      if city.present?
        city_history = city.city_history
        city_history.log = cities_row
        city_history.save!
        city.update!(updated_params)
      else
        City.create!(created_params.merge(updated_params))
      end
    end
  end

  def self.fill_coordinates
    City.where(:coordinates.in => [nil]).each do |city|
      state = State.find_by(uf: city.uf)

      coordinates = Geocoder.search("#{city.name}, #{state.name}, Brazil").first&.coordinates

      city.update!(coordinates: coordinates) if coordinates
    end
  end
end
