class CreateAccidents < ActiveRecord::Migration
  def up
    create_table :accidents do |p|
        p.string :checksum
        p.date :date
        p.string :location
        p.string :operator
        p.string :aircraft_type
        p.string :registration
        p.integer :fatalities
        p.integer :total_passengers
        p.integer :ground_fatalities
        p.float :latitude
        p.float :longitude
    end
  end

  def down
    drop_table :accidents
  end
end
