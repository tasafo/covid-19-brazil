class Api::Covid19Brazil
  include HTTParty

  base_uri 'https://covid19-brazil-api.now.sh/api/report/v1'

  def brazil
    self.class.get('/brazil')['data']
  end

  def states
    self.class.get('/')['data']
  end

  def by_date(date)
    self.class.get("/brazil/#{date}")['data']
  end
end
