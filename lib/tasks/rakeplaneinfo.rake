require 'mechanize'

task :plane_info do |plane|
	mech = Mechanize.new
	# Load the main page
	mech.get('http://planecrashinfo.com/database.htm') do |main_page|
		# Parse out all the links on the main table
		link_table = main_page.search('table')[1].search('tr').search('td').map{ |n| n.text }

		# Try to go to each valid link and load the data from the table on the page
		link_table.each do |year|
			year = year.gsub(/[^0-9 ]/, '')
			if year.length > 0 && year.length < 6
				year_page = main_page.link_with(:text => year).click
				row_data = year_page.search('table').search('tr')
				
				count = 0;
				row_data.each do |row|
					puts row
					next if row
					if count > 0
						column_data = row.search('td').map{ |c| c.text }
						# p column_data
					end
					count+=1
				end

				# Now take the data which is csv format, and dump it into a model
				# lines = flight_data
				# header = lines.shift.strip
				# keys = header.split(',')
				# lines.each do |line|
				    # params = {}
				    # values = line.strip.split(',')
				    # keys.each_with_index do |key,i|
				        # params[key] = values[i]
				    # end
				   #  Module.const_get(args[:model]).create(params)
				# end
			end
		end
	end
end