class AddUser < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name,   :null => false, :unique => true
      t.string :token,  :null => false
    end
  end
end
