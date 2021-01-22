class City
  include Mongoid::Document

  field :name, type: String
  field :slug, type: String
  field :uf, type: String
  field :deaths, type: Integer, default: 0
  field :confirmed, type: Integer, default: 0
  field :ibge_code, type: Integer
  field :date, type: Date
  field :coordinates, type: Array
  field :log, type: Array

  index({ ibge_code: 1 }, { background: true })
  index({ uf: 1 }, { background: true })
  index({ slug: 1 }, { background: true })

  def self.setup
    results = Api::BrasilIo.dataset(1)

    cities_log = results.select { |log| log['place_type'] == 'city' && log['city'] != 'Importados/Indefinidos' }
                        .group_by { |log| log['city_ibge_code'] } if results

    return unless cities_log

    cities_log.each do |ibge_code, cities_row|
      last_update = cities_row.find { |city| city['is_last'] }

      city_name = last_update['city']
      city_ibge_code = last_update['city_ibge_code']

      filter_keys = %w[date confirmed deaths]
      city_log_json = cities_row.map { |city| city.slice(*filter_keys) }

      updated_params = {
        deaths: last_update['deaths'].to_i,
        confirmed: last_update['confirmed'].to_i,
        date: last_update['date']
      }

      created_params = {
        name: city_name,
        slug: city_name.parameterize,
        uf: last_update['state'],
        ibge_code: city_ibge_code.to_i,
        log: [city_log_json]
      }

      city = City.find_by(ibge_code: city_ibge_code)

      if city.present?
        city.update_attributes!(updated_params)
        city_log_db = city.log

        city_log_json.each do |log_json|
          log_found = city_log_db.find { |log| log['date'] == log_json['date'] }

          unless log_found
            city_log_db << log_json
            city.save
          end
        end
      else
        City.create!(created_params.merge(updated_params))
      end
    end
  end

  def self.fill_coordinates
    states = State.all.map { |state| state.attributes.slice('uf', 'name') }
    cities = City.where(:ibge_code.nin => [0], :coordinates.in => [nil])

    cities.each do |city|
      state = select_state(states, city.uf)
      search = "#{city.name}, #{state['name']}, Brazil"

      coordinates = Geocoder.search(search).first&.coordinates

      city.update_attribute(:coordinates, coordinates) if coordinates
    end
  end

  def self.select_state(states, acronym)
    states.select { |state_| state_['uf'] == acronym }.first
  end
end
