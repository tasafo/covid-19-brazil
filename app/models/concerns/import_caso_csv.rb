require 'open-uri'

class ImportCasoCsv
  def self.download(url)
    file_gz = url.split('/').last
    file_csv = file_gz.delete_suffix('.gz')

    begin
      puts "> Realizando o download de #{url}..."

      URI.open(file_gz, 'wb') do |file|
        file << URI.open(url).read
      end

      system "gunzip #{file_gz}"

      run(file_csv)

      File.delete(file_csv) if File.exist?(file_csv)
    rescue OpenURI::HTTPError => e
      File.delete(file_gz) if File.exist?(file_gz)
      puts "Erro: #{e.message}"
      puts "Não foi possível realizar o download do arquivo #{url}"
    end
  end

  def self.run(file_path)
    fields = %w[date state city place_type confirmed deaths order_for_place
                is_last estimated_population_2019 city_ibge_code
                confirmed_per_100k_inhabitants death_rate]

    puts "> Importando dados de #{file_path}..."

    CSV.foreach(file_path) do |row|
      record = Hash[*fields.zip(row).flatten]
      city_name = record['city'].to_s
      city_ibge_code = record['city_ibge_code'].to_i
      date = record['date']

      params = {
        name: city_name,
        slug: city_name.parameterize,
        uf: record['state'],
        ibge_code: city_ibge_code,
        deaths: record['deaths'].to_i,
        confirmed: record['confirmed'].to_i,
        date: date
      }

      log = params.slice(:date, :confirmed, :deaths)

      if record['place_type'] == 'city' && city_name != 'Importados/Indefinidos'
        if record['is_last'] == 'True'
          City.create(params.merge(log: [log]))
        else
          city = City.find_by(ibge_code: city_ibge_code)
          city.log << log
          city.save
        end
      end
    end
  end
end
