class AddUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name,     :null => false, :unique => true
      t.string :username, :null => false, :unique => true
      t.string :password, :null => false
    end
  end
end
