class CreateAccidents < ActiveRecord::Migration
  def change
    create_table :accidents do |t|

      t.timestamps
    end
  end
end
