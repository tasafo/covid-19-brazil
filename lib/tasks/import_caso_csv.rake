namespace :db do
  namespace :import do
    desc 'Import Caso CSV'
    task :caso_csv, [:url] do |_task, args|
      ImportCasoCsv.download(args[:url])
    end
  end
end
