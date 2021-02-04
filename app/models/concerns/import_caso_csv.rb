require 'open-uri'

class ImportCasoCsv
  def self.download(date_filter = nil)
    url = ENV['URL']

    if url.blank?
      puts 'Informe a URL para realizar o download'
      exit 0
    end

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

      run(file_csv, date_filter)

      delete_file(file_csv)
      delete_file("#{file_csv}.tmp")
    rescue OpenURI::HTTPError => e
      delete_file(file_gz)
      puts "Erro: #{e.message}"
      puts "Não foi possível realizar o download do arquivo #{url}"
    end
  end

  def self.run(file_path, date_filter = nil)
    fields = line_number(file_path, 0)
    tmp_file = "#{file_path}.tmp"
    state_city = ''
    logs = []
    city = nil

    system "sed '/^date/d; /,,state/d; /Indefinidos/d;' #{file_path} > #{tmp_file}"
    system "sed -i '/#{date_filter}/!d;' #{tmp_file}" if date_filter

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
      new_state_city = "#{state}-#{city_name}"

      if state_city != new_state_city
        state_city = new_state_city

        if line != 1
          city.update_log(logs, date_filter)
          logs = []
        end

        params = {
          name: city_name,
          slug: city_name.parameterize,
          uf: state,
          ibge_code: city_ibge_code,
          deaths: deaths,
          confirmed: confirmed,
          date: date,
          log: []
        }

        city = City.find_by(ibge_code: city_ibge_code)

        if city
          city.update(params.slice(:date, :confirmed, :deaths))
        else
          city = City.create(params)
        end
      end

      logs << { date: date, confirmed: confirmed, deaths: deaths }

      city.update_log(logs, date_filter) if line == lines

      line += 1
    end
  end

  def self.line_number(file, number)
    IO.readlines(file, chomp: true)[number].split(',')
  end

  def self.delete_file(file)
    File.delete(file) if File.exist?(file)
  end
end
