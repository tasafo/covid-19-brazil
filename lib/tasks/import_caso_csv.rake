namespace :db do
  namespace :import do
    desc 'Import Caso CSV'
    task caso_csv: :environment do
      ImportCasoCsv.download
    end
  end
end
