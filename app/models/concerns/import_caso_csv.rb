require 'open-uri'

class ImportCasoCsv
  def self.download(url)
    file_gz = url.split('/').last
    file_csv = file_gz.delete_suffix('.gz')

    begin
      unless File.exist?(file_csv)
        puts "> Realizando o download de #{url} ..."

        URI.open(file_gz, 'wb') do |file|
          file << URI.open(url).read
        end

        system "gunzip #{file_gz}"
      end

      run(file_csv)

      delete_file(file_csv)
      delete_file("#{file_csv}.tmp")
    rescue OpenURI::HTTPError => e
      delete_file(file_gz)
      puts "Erro: #{e.message}"
      puts "Não foi possível realizar o download do arquivo #{url}"
    end
  end

  def self.run(file_path)
    fields = line_number(file_path, 0)
    tmp_file = "#{file_path}.tmp"
    state_city = ''
    logs = []

    system "sed '/^date/d; /,,state/d; /Indefinidos/d;' #{file_path} > #{tmp_file}"

    lines = IO.readlines(tmp_file).size
    line = 1

    puts "> Importando dados de #{file_path} ..."

    CSV.foreach(tmp_file) do |row|
      puts "> Registro #{line} / #{lines}"

      record = Hash[*fields.zip(row).flatten]

      state = record['state']
      city_name = record['city'].to_s
      city_ibge_code = record['city_ibge_code'].to_i
      date = record['date']
      deaths = record['deaths'].to_i
      confirmed = record['confirmed'].to_i

      if record['is_last'] == 'True'
        if line != 1 && state_city != "#{state}-#{city_name}"
          update_city(logs)
          state_city = "#{state}-#{city_name}"
          logs = []
        end

        params = {
          name: city_name,
          slug: city_name.parameterize,
          uf: state,
          ibge_code: city_ibge_code,
          deaths: deaths,
          confirmed: confirmed,
          date: date
        }

        City.create(params)
      end

      logs << { date: date, confirmed: confirmed, deaths: deaths }

      update_city(logs) if line == lines

      line += 1
    end
  end

  def self.line_number(file, number)
    IO.readlines(file, chomp: true)[number].split(',')
  end

  def self.delete_file(file)
    File.delete(file) if File.exist?(file)
  end

  def self.update_city(logs)
    city = City.last
    city.update(log: logs)
  end
end
