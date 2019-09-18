class AddConditionToResults < ActiveRecord::Migration[5.2]

  def change
    add_column :results, :condition, :string
  end
end
