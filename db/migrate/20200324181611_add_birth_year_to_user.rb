class AddBirthYearToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birth_year, :integer
  end
end
