class Api::BrasilIo
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

  def self.dataset(page)
    api_dataset = Api::BrasilIo.new(page)

    if api_dataset.next.nil?
      api_dataset.results
    else
      api_dataset.results + dataset(page + 1)
    end
  end
end
