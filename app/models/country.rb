class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :deaths, type: Integer
  field :confirmed, type: Integer
  field :recovered, type: Integer
  field :active, type: Integer
  field :datetime, type: DateTime

  def self.brazil_setup
    covid = Api::Covid19Brazil.new
    data = covid.brazil

    brazil = Country.find_by(name: data['country'])
    params = {
      name: data['country'],
      deaths: data['deaths'],
      confirmed: data['confirmed'],
      recovered: data['recovered'],
      active: data['cases'],
      datetime: data['updated_at']
    }
    if brazil.present?
      brazil = Country.update(params)
    else
      brazil = Country.create!(params)
    end
  end
end
