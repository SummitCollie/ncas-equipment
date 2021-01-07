class AddDisplayNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :display_name, :string
    add_index :users, :display_name, unique: true
  end
end
