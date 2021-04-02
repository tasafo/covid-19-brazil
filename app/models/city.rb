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

  index({ confirmed: 1 }, { background: true })
  index({ ibge_code: 1 }, { background: true })
  index({ uf: 1 }, { background: true })
  index({ slug: 1 }, { background: true })

  def update_log(logs, date = nil)
    if date
      log_found = log.find { |log| log['date'] == date }

      unless log_found
        log << logs.first
        save
      end
    else
      update(log: logs)
    end
  end

  def self.setup
    date = ENV['DATE']

    if date.blank?
      yesterday = Date.today - 1
      date = yesterday.strftime('%F')
    end

    ImportCasoCsv.download(date)
  end

  def self.fill_coordinates
    states = State.all.map { |state| state.attributes.slice('uf', 'name') }
    cities = City.batch_size(1000).no_timeout
                 .where(:ibge_code.nin => [0], :coordinates.in => [nil])
                 .only(:name, :uf, :coordinates)

    puts "Cidades: #{cities.count}"

    cities.each do |city|
      state = select_state(states, city.uf)
      search = "#{city.name}, #{state['name']}, Brazil"

      puts "Buscando #{search} ..."

      coordinates = geo_search(search, state['uf'])

      city.update_attribute(:coordinates, coordinates) if coordinates
    end
  end

  def self.select_state(states, acronym)
    states.select { |state_| state_['uf'] == acronym }.first
  end

  def self.geo_search(search, state)
    coordinates = Geocoder.search(search).first&.coordinates

    coordinates = coord(search, state, 1) unless coordinates

    coordinates = coord(search, nil, 2) unless coordinates

    coordinates
  end

  def self.coord(search, state, option)
    new_search = search.split(',')

    case option
    when 1
      new_search[1] = " #{state}"
    when 2
      new_search.delete_at(1)
    end

    Geocoder.search(new_search.join(',')).first&.coordinates
  end
end
