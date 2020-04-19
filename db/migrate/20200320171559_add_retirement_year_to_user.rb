class AddRetirementYearToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :retirement_year, :integer
  end
end
