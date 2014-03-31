require 'mechanize'
require 'digest'

namespace :import do
    task :plane_info_csv => :environment do
        require 'csv'    

        csv_text = File.read('/home/aspittal/placcidents/lib/tasks/data/placcidents.csv')
        csv = CSV.parse(csv_text, :headers => true)
        csv.each do |row|
          Accident.create!(row.to_hash)
        end
    end
end