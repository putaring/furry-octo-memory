class AddOccupationToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :occupation, :string, limit: 1500
    add_column :profiles, :preference, :string, limit: 1500
  end
end
