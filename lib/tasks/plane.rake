require 'mechanize'
require 'digest'

namespace :import do
	task :plane_info => :environment do
		mech = Mechanize.new
		# Load the main page
		mech.get('http://planecrashinfo.com/database.htm') do |main_page|
			# Parse out all the links on the main table
			link_table = main_page.search('table')[1].search('tr').search('td').map{ |n| n.text }
			# Try to go to each valid link and load the data from the table on the page
			link_table.each do |year|
				year = year.gsub(/[^0-9]/, '')
				if year.length > 0 && year.length < 6
					# some ridiculous code because of a "bug" on his webpage
					if year == '1929'
						link = year + '/' + year + '.htm'
					else 
						link = '/' + year + '/' + year + '.htm'
					end
					year_page = main_page.link_with(:href => link).click
					row_data = year_page.search('table').search('tr')
					
					# Remove the header data
					row_data.shift

					# Parse each row and insert it!
					row_data.each do |row|
						column_data = row.search('td').map{ |c| c.inner_html }
						data = {}
						data[:date] = column_data[0].gsub(/<\/?[^>]*>/, "")

						loc_op = column_data[1].gsub(/<.*?>(.*)?<br>(.*)\n<.*/m,"\\1|\\2")
						data[:location] = loc_op.split('|')[0].strip
						data[:operator] = loc_op.split('|')[1].strip

						type_reg = column_data[2].gsub(/<.*?>(.*)?<br>(.*)<.*/m,"\\1|\\2")
						data[:aircraft_type] = type_reg.split('|')[0].gsub(/[\s\t\r\n\f]/m, ' ').strip
						data[:registration] = type_reg.split('|')[1].gsub(/[\s\t\r\n\f]/, ' ').strip

						# I really need a better data source, this site doesn't have ground fatalities in
						# 1930, so we need a special case. A better structured regex could probably handle this case
						if year != '1930'
							fatals = column_data[3].gsub(/<.*?>(.*)?\/(.*)?\((.*)?\)<.*/, "\\1|\\2|\\3")
							data[:fatalities] = fatals.split('|')[0]
							data[:total_passengers] = fatals.split('|')[1]
							data[:ground_fatalities] = fatals.split('|')[2]
						else 
							fatals = column_data[3].gsub(/<.*?>(.*)?\/(.*)?<.*/, "\\1|\\2")
							data[:fatalities] = fatals.split('|')[0]
							data[:total_passengers] = fatals.split('|')[1]
							data[:ground_fatalities] = 0;
						end

						data[:checksum] = Digest::MD5.hexdigest(data.map{ |data| data.join('|')}.join('|'))
						# Make sure we don't insert duplicate data, use the checksum
						exists = Accident.where('checksum = ?', data[:checksum])
						if exists.empty? 
							p data
							begin
								Accident.new(data).save
							rescue Exception
								p data[:date] + " " + data[:location] + " Something was wrong with this data! Not Inserted."
							end
						else
							p data[:date] + " " + data[:location] + " Duplicate data not inserted"
						end
					end
				end
			end
		end
	end
end