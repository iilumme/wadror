class AddIcedToUser < ActiveRecord::Migration
  def change
    add_column :users, :ided, :boolean
  end
end
