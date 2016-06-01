class AddLanguageToUsers < ActiveRecord::Migration
  def change
    change_column :users, :language, "char(3)", null: false
  end
end
