class AlterIsTurfToSurfaceOfRaces < ActiveRecord::Migration[5.2]

  def up
    add_column :races, :surface, :integer, null: false, default: 0
    remove_column :races, :is_turf
  end

  def down
    add_column :races, :is_turf, :boolean, null: false, default: true
    remove_column :races, :surface
  end
end
