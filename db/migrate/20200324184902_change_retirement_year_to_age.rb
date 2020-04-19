class ChangeRetirementYearToAge < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :retirement_year, :retirement_age
  end
end
