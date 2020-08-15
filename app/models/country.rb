class Country
  include Mongoid::Document

  field :name, type: String
  field :deaths, type: Integer, default: 0
  field :confirmed, type: Integer, default: 0
  field :recovered, type: Integer, default: 0
  field :active, type: Integer, default: 0
  field :datetime, type: DateTime
  field :coordinates, type: Array

  index({ name: 1 }, { background: true })

  def self.brazil_setup
    covid = Api::Covid19Brazil.new
    data = covid.brazil
    country_name = data['country']

    country = Country.find_by(name: country_name)

    params = {
      name: country_name,
      deaths: data['deaths'],
      confirmed: data['confirmed'],
      recovered: data['recovered'],
      active: data['cases'],
      datetime: data['updated_at'],
      coordinates: Geocoder.search(country_name).first&.coordinates
    }

    if country.present?
      country.update_attributes!(params)
    else
      Country.create!(params)
    end
  end
end
