class DropSearchesFromDb < ActiveRecord::Migration
  def down
    drop_table :searches
  end
end
