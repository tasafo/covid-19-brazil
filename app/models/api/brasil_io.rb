class Api::BrasilIo
  include HTTParty

  base_uri 'https://api.brasil.io/dataset/covid19'

  def initialize(page)
    @options = {
      headers: { 'Authorization' => "Token #{ENV['BRASILIO_TOKEN']}" },
      query: { format: 'json', page: page }
    }
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

  def self.dataset(page)
    api_dataset = Api::BrasilIo.new(page)

    api_dataset.results
  end
end
