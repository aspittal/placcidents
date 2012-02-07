class CreateAccidents < ActiveRecord::Migration
  def up
    create_table :accidents do |p|
        p.string :id
        p.date :event_date
        p.string :location
        p.string :country
        p.float :latitude
        p.float :longitude
        p.string :airport_code
        p.string :airport_name
        p.string :injury_severity
        p.string :aircraft_damage
        p.string :aircraft_category
        p.string :make
        p.string :model
        p.string :air_carrier
        p.string :total_fatal_injuries
        p.string :total_serious_injuries
        p.string :total_minor_injuries
        p.string :total_uninjured
        p.string :weather_condition
    end
  end

  def down
    drop_table :accidents
  end
end
