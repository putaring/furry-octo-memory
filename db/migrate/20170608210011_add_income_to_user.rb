class AddIncomeToUser < ActiveRecord::Migration
  def change
    add_column :users, :income, :integer
  end
end
