class AddAccountFields < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :initial_balance, :float
    add_column :accounts, :annual_roi_percentage, :float
    add_column :accounts, :annual_contribution, :float
    add_column :accounts, :user_id, :integer
  end
end
