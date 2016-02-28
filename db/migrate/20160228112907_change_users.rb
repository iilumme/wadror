class ChangeUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :ided, :iced
    end
  end
end
