class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :deaths, type: Integer, default: 0
  field :confirmed, type: Integer, default: 0
  field :recovered, type: Integer, default: 0
  field :active, type: Integer, default: 0
  field :datetime, type: DateTime

  index({ name: 1 }, { background: true })

  def self.brazil_setup
    covid = Api::Covid19Brazil.new
    data = covid.brazil

    country = Country.find_by(name: data['country'])

    last_cases_by_dates = CasesByDate.last

    params = {
      name: data['country'],
      deaths: last_cases_by_dates.deaths,
      confirmed: data['confirmed'],
      recovered: data['recovered'],
      active: data['cases'],
      datetime: data['updated_at']
    }

    if country.present?
      country.update!(params)
    else
      Country.create!(params)
    end
  end
end
